# ==============================================================================
# RDS Module
# ==============================================================================

resource "aws_db_subnet_group" "this" {
  name       = var.identifier
  subnet_ids = var.subnet_ids

  tags = merge(var.tags, {
    Name = var.identifier
  })
}

resource "aws_db_instance" "this" {
  identifier = var.identifier

  engine            = var.engine
  engine_version    = var.engine_version
  instance_class    = var.instance_class
  allocated_storage = var.allocated_storage
  storage_type      = var.storage_type

  db_name                       = var.db_name
  username                      = var.username
  manage_master_user_password   = true
  master_user_secret_kms_key_id = var.master_user_secret_kms_key_id
  port                          = var.port

  publicly_accessible = var.publicly_accessible
  multi_az            = var.multi_az
  skip_final_snapshot = var.skip_final_snapshot
  deletion_protection = var.deletion_protection

  backup_retention_period = var.backup_retention_period
  backup_window           = var.backup_window
  maintenance_window      = var.maintenance_window

  vpc_security_group_ids = var.vpc_security_group_ids
  db_subnet_group_name   = aws_db_subnet_group.this.name

  storage_encrypted = var.storage_encrypted
  kms_key_id        = var.kms_key_id

  tags = merge(var.tags, {
    Name = var.identifier
  })
}
