# ==============================================================================
# Development Environment Variables
# ==============================================================================
# Usage: terraform apply -var-file="env/dev.tfvars"
# ==============================================================================

# General Configuration
env    = "dev"
region = "us-east-2"

# VPC Configuration
vpc_cidr           = "10.0.0.0/16"
availability_zones = ["us-east-2a", "us-east-2b"]

# EKS Configuration
cluster_name          = "eks-demo-dev"
cluster_version       = "1.35"
node_instance_types   = ["t3.medium"]
node_desired_capacity = 2
node_max_capacity     = 3
node_min_capacity     = 1

# RDS Configuration
db_instance_class          = "db.t4g.micro"
db_allocated_storage       = 20
db_engine_version          = "16.3"
db_name                    = "appdb"
db_username                = "admin"
db_port                    = 5432
db_backup_retention_period = 1
db_backup_window           = "03:00-04:00"
db_maintenance_window      = "Mon:04:00-Mon:05:00"

# ElastiCache Configuration
redis_node_type                = "cache.t3.micro"
redis_num_cache_nodes          = 1
redis_engine_version           = "7.0"
redis_port                     = 6379
redis_snapshot_retention_limit = 0
redis_snapshot_window          = "05:00-06:00"

# MSK Configuration
msk_broker_instance_type   = "kafka.t3.small"
msk_number_of_broker_nodes = 2
msk_kafka_version          = "3.5.1"
msk_broker_ebs_volume_size = 100

# ECR Configuration
ecr_tag_mutability        = "MUTABLE"
ecr_lifecycle_image_count = 5

# KMS Configuration
kms_deletion_window_in_days = 7

# EKS Endpoint Configuration
endpoint_public_access  = true
endpoint_private_access = true
public_access_cidrs     = ["0.0.0.0/0"] # Restrict in production

# Monitoring & Logging
log_retention_in_days   = 7
enable_cloudwatch_agent = true
enable_xray             = false
enable_ssm_access       = true

# Security & Alarms
encryption_resources = ["secrets"]
alarm_actions        = []

# Additional Tags
additional_tags = {}
