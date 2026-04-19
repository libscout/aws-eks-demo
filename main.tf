# ==============================================================================
# Main Infrastructure Resources - Using Community Modules Directly
# ==============================================================================



module "infra" {
  source = "./infra"

  environment     = local.env
  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version

  region             = var.region
  availability_zones = var.availability_zones

  # EKS
  endpoint_public_access  = var.endpoint_public_access
  endpoint_private_access = var.endpoint_private_access
  public_access_cidrs     = var.public_access_cidrs
  enable_cloudwatch_agent = var.enable_cloudwatch_agent
  enable_xray             = var.enable_xray
  enable_ssm_access       = var.enable_ssm_access
  alarm_actions           = []

  # Security & Tags
  encryption_resources = var.encryption_resources
  additional_tags      = var.additional_tags

  # Node group
  node_desired_capacity = var.node_desired_capacity
  node_instance_types   = var.node_instance_types
  node_max_capacity     = var.node_max_capacity
  node_min_capacity     = var.node_min_capacity

  # VPC
  vpc_cidr = var.vpc_cidr

  # RDS
  db_allocated_storage       = var.db_allocated_storage
  db_instance_class          = var.db_instance_class
  db_username                = var.db_username
  db_engine_version          = var.db_engine_version
  db_name                    = var.db_name
  db_port                    = var.db_port
  db_backup_retention_period = var.db_backup_retention_period
  db_backup_window           = var.db_backup_window
  db_maintenance_window      = var.db_maintenance_window

  # ElastiCache
  redis_node_type                = var.redis_node_type
  redis_num_cache_nodes          = var.redis_num_cache_nodes
  redis_engine_version           = var.redis_engine_version
  redis_port                     = var.redis_port
  redis_snapshot_retention_limit = var.redis_snapshot_retention_limit
  redis_snapshot_window          = var.redis_snapshot_window

  # MSK
  msk_broker_instance_type   = var.msk_broker_instance_type
  msk_number_of_broker_nodes = var.msk_number_of_broker_nodes
  msk_kafka_version          = var.msk_kafka_version
  msk_broker_ebs_volume_size = var.msk_broker_ebs_volume_size

  # ECR
  ecr_tag_mutability        = var.ecr_tag_mutability
  ecr_lifecycle_image_count = var.ecr_lifecycle_image_count

  # KMS
  kms_deletion_window_in_days = var.kms_deletion_window_in_days

  # Unified log retention
  log_retention_in_days = var.log_retention_in_days
}
