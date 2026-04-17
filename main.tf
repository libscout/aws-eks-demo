# ==============================================================================
# Main Infrastructure Resources - Using Community Modules Directly
# ==============================================================================

# ==============================================================================
# KMS Key (Cross-cutting encryption)
# ==============================================================================

resource "aws_kms_key" "main" {
  description             = "KMS key for encrypting EKS demo resources"
  deletion_window_in_days = 7
  enable_key_rotation     = true

  tags = merge(var.additional_tags, {
    Name = "${var.cluster_name}-kms-key"
  })
}

# ==============================================================================
# Secrets Manager (RDS Credentials)
# ==============================================================================

resource "aws_secretsmanager_secret" "rds_credentials" {
  name        = "${var.cluster_name}/rds-credentials"
  description = "RDS PostgreSQL master credentials"
  kms_key_id  = aws_kms_key.main.arn

  tags = merge(var.additional_tags, {
    Name = "${var.cluster_name}/rds-credentials"
  })
}

resource "aws_secretsmanager_secret_version" "rds_credentials" {
  secret_id = aws_secretsmanager_secret.rds_credentials.id
  secret_string = jsonencode({
    username = var.db_username
    password = var.db_password
  })
}

# ==============================================================================
# VPC and Networking
# ==============================================================================

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "6.6.1"

  name = "${var.cluster_name}-vpc"
  cidr = var.vpc_cidr

  azs             = var.availability_zones
  private_subnets = [for i, az in var.availability_zones : cidrsubnet(var.vpc_cidr, 8, i)]
  public_subnets  = [for i, az in var.availability_zones : cidrsubnet(var.vpc_cidr, 8, i + length(var.availability_zones))]

  enable_nat_gateway   = true
  single_nat_gateway   = var.environment == "dev"
  enable_dns_hostnames = true
  enable_dns_support   = true

  # VPC Flow Logs for security monitoring
  enable_flow_log                      = true
  create_flow_log_cloudwatch_log_group = true
  create_flow_log_cloudwatch_iam_role  = true
  flow_log_max_aggregation_interval    = 60

  tags = merge(var.additional_tags, {
    Name = "${var.cluster_name}-vpc"
  })
}

# ==============================================================================
# EKS Cluster & Node Groups
# ==============================================================================

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "21.18.0"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  cluster_endpoint_public_access  = true
  cluster_endpoint_private_access = true

  # Enable IRSA for pod-level permissions
  enable_irsa = true

  # Cluster logging
  cluster_enabled_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]

  eks_managed_node_groups = {
    default = {
      instance_types = var.node_instance_types
      min_size       = var.node_min_capacity
      max_size       = var.node_max_capacity
      desired_size   = var.node_desired_capacity

      # Enable IMDSv2
      metadata_options = {
        http_endpoint = "enabled"
        http_tokens   = "required"
      }
    }
  }

  tags = merge(var.additional_tags, {
    Name = var.cluster_name
  })
}

# ==============================================================================
# RDS PostgreSQL
# ==============================================================================

module "rds" {
  source  = "terraform-aws-modules/rds/aws"
  version = "7.2.0"

  identifier = "${var.cluster_name}-postgres"

  engine               = "postgres"
  engine_version       = "15.4"
  family               = "postgres15"
  major_engine_version = "15"
  instance_class       = var.db_instance_class

  allocated_storage     = var.db_allocated_storage
  storage_type          = "gp3"
  storage_encrypted     = true
  kms_key_id            = aws_kms_key.main.arn

  db_name  = "appdb"
  username = var.db_username
  password = var.db_password

  port                     = "5432"
  publicly_accessible      = false
  multi_az                 = var.environment == "prod"
  skip_final_snapshot      = var.environment == "dev"
  deletion_protection      = var.environment == "prod"
  backup_retention_period  = var.environment == "prod" ? 7 : 1
  backup_window            = "03:00-04:00"
  maintenance_window       = "Mon:04:00-Mon:05:00"

  vpc_security_group_ids = [module.rds_sg.security_group_id]
  subnet_ids             = module.vpc.private_subnets

  tags = merge(var.additional_tags, {
    Name = "${var.cluster_name}-postgres"
  })
}

module "rds_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.3.1"

  name        = "${var.cluster_name}-rds-sg"
  description = "Security group for RDS PostgreSQL instance"
  vpc_id      = module.vpc.vpc_id

  ingress_cidr_blocks = []
  ingress_rules       = ["postgresql-tcp"]
  ingress_with_source_security_group_id = [
    {
      rule                     = "postgresql-tcp"
      source_security_group_id = module.eks.node_security_group_id
    }
  ]

  egress_rules = ["all-all"]

  tags = merge(var.additional_tags, {
    Name = "${var.cluster_name}-rds-sg"
  })
}

# ==============================================================================
# ElastiCache Redis
# ==============================================================================

module "elasticache" {
  source  = "terraform-aws-modules/elasticache/aws"
  version = "1.11.0"

  cluster_id           = "${var.cluster_name}-redis"
  description          = "Redis cluster for ${var.cluster_name}"
  engine               = "redis"
  engine_version       = "7.0"
  node_type            = var.redis_node_type
  num_cache_nodes      = var.redis_num_cache_nodes
  port                 = 6379
  apply_immediately    = true

  subnet_ids         = module.vpc.private_subnets
  security_group_ids = [module.redis_sg.security_group_id]

  transit_encryption_enabled = true
  at_rest_encryption_enabled = true
  kms_key_id                 = aws_kms_key.main.arn

  automatic_failover_enabled = var.environment == "prod"
  multi_az_enabled           = var.environment == "prod"
  snapshot_retention_limit   = var.environment == "prod" ? 7 : 0
  snapshot_window            = "05:00-06:00"

  tags = merge(var.additional_tags, {
    Name = "${var.cluster_name}-redis"
  })
}

module "redis_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.3.1"

  name        = "${var.cluster_name}-redis-sg"
  description = "Security group for ElastiCache Redis cluster"
  vpc_id      = module.vpc.vpc_id

  ingress_cidr_blocks = []
  ingress_rules       = ["redis-tcp"]
  ingress_with_source_security_group_id = [
    {
      rule                     = "redis-tcp"
      source_security_group_id = module.eks.node_security_group_id
    }
  ]

  egress_rules = ["all-all"]

  tags = merge(var.additional_tags, {
    Name = "${var.cluster_name}-redis-sg"
  })
}

# ==============================================================================
# MSK Kafka
# ==============================================================================

module "msk" {
  source  = "terraform-aws-modules/msk-kafka-cluster/aws"
  version = "3.1.0"

  cluster_name           = "${var.cluster_name}-kafka"
  kafka_version          = "3.5.1"
  number_of_broker_nodes = var.msk_number_of_broker_nodes

  broker_node_client_subnets  = module.vpc.private_subnets
  broker_node_instance_type   = var.msk_broker_instance_type
  broker_node_security_groups = [module.msk_sg.security_group_id]
  broker_node_ebs_volume_size = 100

  encryption_in_transit_client_broker = "TLS"

  logging_enabled = true
  cloudwatch_log_group_name          = "/aws/msk/${var.cluster_name}"
  cloudwatch_log_group_retention_in_days = var.environment == "prod" ? 90 : 30

  tags = merge(var.additional_tags, {
    Name = "${var.cluster_name}-kafka"
  })
}

module "msk_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.3.1"

  name        = "${var.cluster_name}-msk-sg"
  description = "Security group for MSK Kafka cluster"
  vpc_id      = module.vpc.vpc_id

  ingress_cidr_blocks = []
  ingress_rules       = ["kafka-tcp"]
  ingress_with_source_security_group_id = [
    {
      rule                     = "kafka-tcp"
      source_security_group_id = module.eks.node_security_group_id
    }
  ]

  egress_rules = ["all-all"]

  tags = merge(var.additional_tags, {
    Name = "${var.cluster_name}-msk-sg"
  })
}

# ==============================================================================
# ECR Repository
# ==============================================================================

module "ecr" {
  source  = "terraform-aws-modules/ecr/aws"
  version = "3.2.0"

  repository_name = "${var.cluster_name}/api"

  repository_image_tag_mutability = "MUTABLE"
  repository_image_scanning_configuration = {
    scan_on_push = true
  }
  repository_encryption_configuration = {
    encryption_type = "KMS"
    kms_key         = aws_kms_key.main.arn
  }

  repository_lifecycle_policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Keep last 10 images"
        selection = {
          tagStatus     = "any"
          countType     = "imageCountMoreThan"
          countNumber   = 10
        }
        action = {
          type = "expire"
        }
      }
    ]
  })

  tags = merge(var.additional_tags, {
    Name = "${var.cluster_name}/api"
  })
}
