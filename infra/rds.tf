# ==============================================================================
# RDS PostgreSQL
# ==============================================================================

module "rds" {
  source = "../modules/rds"

  identifier     = "${var.cluster_name}-postgres"
  engine         = "postgres"
  engine_version = "18.3"
  instance_class = var.db_instance_class

  allocated_storage = var.db_allocated_storage
  storage_type      = "gp3"
  storage_encrypted = true
  kms_key_id        = aws_kms_key.main.arn

  db_name                       = "appdb"
  username                      = var.db_username
  master_user_secret_kms_key_id = aws_kms_key.main.arn

  port                    = 5432
  publicly_accessible     = false
  multi_az                = var.environment == "prod"
  skip_final_snapshot     = var.environment == "dev"
  deletion_protection     = var.environment == "prod"
  backup_retention_period = var.environment == "prod" ? 7 : 1
  backup_window           = "03:00-04:00"
  maintenance_window      = "Mon:04:00-Mon:05:00"

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
