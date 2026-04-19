variable "env" {
  type = string
}

# General Configuration
variable "region" {
  description = "The AWS region to deploy resources into."
  type        = string
}

# VPC Configuration
variable "availability_zones" {
  description = "List of availability zones to use for subnets."
  type        = list(string)
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC."
  type        = string
}

# EKS Configuration
variable "cluster_name" {
  description = "The name of the EKS cluster."
  type        = string
}

variable "cluster_version" {
  description = "The Kubernetes version for the EKS cluster."
  type        = string
}

variable "node_instance_types" {
  description = "List of EC2 instance types for the EKS managed node group."
  type        = list(string)
}

variable "node_desired_capacity" {
  description = "Desired number of worker nodes."
  type        = number
}

variable "node_max_capacity" {
  description = "Maximum number of worker nodes."
  type        = number
}

variable "node_min_capacity" {
  description = "Minimum number of worker nodes."
  type        = number
}

# RDS Configuration
variable "db_instance_class" {
  description = "The RDS instance type."
  type        = string
}

variable "db_allocated_storage" {
  description = "The allocated storage in gigabytes for the RDS instance."
  type        = number
}

variable "db_username" {
  description = "The master username for the RDS instance."
  type        = string
  sensitive   = true
}

# ElastiCache Configuration
variable "redis_node_type" {
  description = "The instance type for the ElastiCache Redis cluster."
  type        = string
}

variable "redis_num_cache_nodes" {
  description = "The number of cache nodes in the Redis cluster."
  type        = number
}

# MSK Configuration
variable "msk_broker_instance_type" {
  description = "The instance type for MSK brokers."
  type        = string
}

variable "msk_number_of_broker_nodes" {
  description = "The number of broker nodes in the MSK cluster."
  type        = number
}

# RDS Configuration (Additional)
variable "db_engine_version" {
  description = "The PostgreSQL engine version."
  type        = string
}

variable "db_name" {
  description = "The name of the database to create."
  type        = string
}

variable "db_port" {
  description = "The port the RDS instance listens on."
  type        = number
}

variable "db_backup_retention_period" {
  description = "Days to retain RDS backups."
  type        = number
}

variable "db_backup_window" {
  description = "The daily time range during which automated backups are created for RDS."
  type        = string
}

variable "db_maintenance_window" {
  description = "The weekly time range during which system maintenance can occur for RDS."
  type        = string
}

# ElastiCache Configuration (Additional)
variable "redis_engine_version" {
  description = "The Redis engine version."
  type        = string
}

variable "redis_port" {
  description = "The port the Redis cluster listens on."
  type        = number
}

variable "redis_snapshot_retention_limit" {
  description = "Number of days to retain Redis snapshots."
  type        = number
}

variable "redis_snapshot_window" {
  description = "The daily time range during which Redis snapshots are created."
  type        = string
}

# MSK Configuration (Additional)
variable "msk_kafka_version" {
  description = "The Apache Kafka version for the MSK cluster."
  type        = string
}

variable "msk_broker_ebs_volume_size" {
  description = "The EBS volume size in GB for MSK broker nodes."
  type        = number
}

# ECR Configuration
variable "ecr_tag_mutability" {
  description = "The tag mutability setting for the ECR repository."
  type        = string
}

variable "ecr_lifecycle_image_count" {
  description = "Number of images to retain in the ECR lifecycle policy."
  type        = number
}

# KMS Configuration
variable "kms_deletion_window_in_days" {
  description = "Number of days before the KMS key is deleted."
  type        = number
}

# EKS Module Configuration
variable "endpoint_public_access" {
  description = "Whether the EKS public API server endpoint is enabled."
  type        = bool
}

variable "endpoint_private_access" {
  description = "Whether the EKS private API server endpoint is enabled."
  type        = bool
}

variable "public_access_cidrs" {
  description = "List of CIDR blocks that can access the EKS public API server endpoint."
  type        = list(string)
}

variable "log_retention_in_days" {
  description = "Number of days to retain logs for EKS, MSK, VPC Flow Logs, and other services."
  type        = number
}

variable "enable_cloudwatch_agent" {
  description = "Whether to attach the CloudWatch Agent policy to node groups."
  type        = bool
}

variable "enable_xray" {
  description = "Whether to attach the X-Ray Daemon write access policy to node groups."
  type        = bool
}

variable "enable_ssm_access" {
  description = "Whether to attach SSM Managed Instance Core policy to node groups."
  type        = bool
}

variable "encryption_resources" {
  description = "List of Kubernetes resources to encrypt using the KMS key."
  type        = list(string)
}

variable "alarm_actions" {
  description = "List of ARNs for SNS topics to trigger when CloudWatch alarms are in ALARM state."
  type        = list(string)
}

variable "additional_tags" {
  description = "Additional tags to apply to all resources."
  type        = map(string)
}
