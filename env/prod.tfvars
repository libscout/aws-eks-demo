# ==============================================================================
# Production Environment Configuration
# ==============================================================================
# Usage: terraform apply -var-file="env/prod.tfvars"
# ==============================================================================

# General Configuration
env    = "prod"
region = "us-east-2"

# VPC Configuration
vpc_cidr           = "10.0.0.0/16"
availability_zones = ["us-east-2a", "us-east-2b", "us-east-2c"]

# EKS Configuration
cluster_name          = "eks-demo-prod"
cluster_version       = "1.35"
node_instance_types   = ["t3.medium"]
node_desired_capacity = 3
node_max_capacity     = 6
node_min_capacity     = 2

# RDS Configuration
db_instance_class          = "db.t4g.micro"
db_allocated_storage       = 100
db_engine_version          = "16.3"
db_name                    = "appdb"
db_username                = "admin"
db_port                    = 5432
db_backup_retention_period = 7
db_backup_window           = "03:00-04:00"
db_maintenance_window      = "Sun:04:00-Sun:05:00"

# ElastiCache Configuration
redis_node_type                = "cache.t3.micro"
redis_num_cache_nodes          = 2
redis_port                     = 6379
redis_engine_version           = "7.0"
redis_snapshot_retention_limit = 7
redis_snapshot_window          = "05:00-06:00"

# MSK Configuration
msk_broker_instance_type   = "kafka.t3.small"
msk_number_of_broker_nodes = 3
msk_kafka_version          = "3.5.1"
msk_broker_ebs_volume_size = 200

# EKS Endpoint Security
endpoint_public_access  = false
endpoint_private_access = true
public_access_cidrs     = []

# Monitoring & Logging
enable_cloudwatch_agent = true
enable_xray             = true
enable_ssm_access       = true
log_retention_in_days   = 90

# ECR Configuration
ecr_tag_mutability        = "IMMUTABLE"
ecr_lifecycle_image_count = 30

# KMS Configuration
kms_deletion_window_in_days = 30

# Security & Alarms
encryption_resources = ["secrets"]
alarm_actions        = []

# Additional Tags
additional_tags = {}
