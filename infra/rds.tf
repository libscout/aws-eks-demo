# ==============================================================================
# RDS PostgreSQL
# ==============================================================================

module "rds" {
  source = "../modules/rds"

  identifier     = "${var.cluster_name}-postgres"
  engine         = "postgres"
  engine_version = var.db_engine_version
  instance_class = var.db_instance_class

  allocated_storage = var.db_allocated_storage
  storage_type      = "gp3"
  storage_encrypted = true
  kms_key_id        = aws_kms_key.main.arn

  db_name                       = var.db_name
  username                      = var.db_username
  master_user_secret_kms_key_id = aws_kms_key.main.arn

  port                    = var.db_port
  publicly_accessible     = false
  multi_az                = var.environment == "prod"
  skip_final_snapshot     = var.environment == "dev"
  deletion_protection     = var.environment == "prod"
  backup_retention_period = var.db_backup_retention_period
  backup_window           = var.db_backup_window
  maintenance_window      = var.db_maintenance_window

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
      source_security_group_id = module.eks.node_sg_id
    }
  ]

  egress_cidr_blocks = [module.vpc.vpc_cidr_block]
  egress_rules       = ["all-all"]

  tags = merge(var.additional_tags, {
    Name = "${var.cluster_name}-rds-sg"
  })
}
