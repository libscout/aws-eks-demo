# General Configuration
variable "region" {
  description = "The AWS region to deploy resources into."
  type        = string
  default     = "us-east-2"
}

# VPC Configuration
variable "availability_zones" {
  description = "List of availability zones to use for subnets."
  type        = list(string)
  default     = ["us-east-2a", "us-east-2b"]
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC."
  type        = string
  default     = "10.0.0.0/16"
}

# EKS Configuration
variable "cluster_name" {
  description = "The name of the EKS cluster."
  type        = string
  default     = "demo"
}

variable "cluster_version" {
  description = "The Kubernetes version for the EKS cluster."
  type        = string
  default     = "1.35"
}

variable "node_instance_types" {
  description = "List of EC2 instance types for the EKS managed node group."
  type        = list(string)
  default     = ["t3.medium"]
}

variable "node_desired_capacity" {
  description = "Desired number of worker nodes."
  type        = number
  default     = 2
}

variable "node_max_capacity" {
  description = "Maximum number of worker nodes."
  type        = number
  default     = 2
}

variable "node_min_capacity" {
  description = "Minimum number of worker nodes."
  type        = number
  default     = 2
}

# RDS Configuration
variable "db_instance_class" {
  description = "The RDS instance type."
  type        = string
  default     = "db.t4g.micro"
}

variable "db_allocated_storage" {
  description = "The allocated storage in gigabytes for the RDS instance."
  type        = number
  default     = 20
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
  default     = "cache.t3.micro"
}

variable "redis_num_cache_nodes" {
  description = "The number of cache nodes in the Redis cluster."
  type        = number
  default     = 1
}

# MSK Configuration
variable "msk_broker_instance_type" {
  description = "The instance type for MSK brokers."
  type        = string
  default     = "kafka.t3.small"
}

variable "msk_number_of_broker_nodes" {
  description = "The number of broker nodes in the MSK cluster."
  type        = number
  default     = 2
}

# RDS Configuration (Additional)
variable "db_engine_version" {
  description = "The PostgreSQL engine version."
  type        = string
  default     = "16.3"
}

variable "db_name" {
  description = "The name of the database to create."
  type        = string
  default     = "appdb"
}

variable "db_port" {
  description = "The port the RDS instance listens on."
  type        = number
  default     = 5432
}

variable "db_backup_retention_period" {
  description = "Days to retain RDS backups."
  type        = number
  default     = 1
}

variable "db_backup_window" {
  description = "The daily time range during which automated backups are created for RDS."
  type        = string
  default     = "03:00-04:00"
}

variable "db_maintenance_window" {
  description = "The weekly time range during which system maintenance can occur for RDS."
  type        = string
  default     = "Mon:04:00-Mon:05:00"
}

# ElastiCache Configuration (Additional)
variable "redis_engine_version" {
  description = "The Redis engine version."
  type        = string
  default     = "7.0"
}

variable "redis_port" {
  description = "The port the Redis cluster listens on."
  type        = number
  default     = 6379
}

variable "redis_snapshot_retention_limit" {
  description = "Number of days to retain Redis snapshots."
  type        = number
  default     = 0
}

variable "redis_snapshot_window" {
  description = "The daily time range during which Redis snapshots are created."
  type        = string
  default     = "05:00-06:00"
}

# MSK Configuration (Additional)
variable "msk_kafka_version" {
  description = "The Apache Kafka version for the MSK cluster."
  type        = string
  default     = "3.5.1"
}

variable "msk_broker_ebs_volume_size" {
  description = "The EBS volume size in GB for MSK broker nodes."
  type        = number
  default     = 100
}

# ECR Configuration
variable "ecr_tag_mutability" {
  description = "The tag mutability setting for the ECR repository."
  type        = string
  default     = "MUTABLE"
}

variable "ecr_lifecycle_image_count" {
  description = "Number of images to retain in the ECR lifecycle policy."
  type        = number
  default     = 10
}

# KMS Configuration
variable "kms_deletion_window_in_days" {
  description = "Number of days before the KMS key is deleted."
  type        = number
  default     = 7
}

# EKS Module Configuration
variable "endpoint_public_access" {
  description = "Whether the EKS public API server endpoint is enabled."
  type        = bool
  default     = true
}

variable "endpoint_private_access" {
  description = "Whether the EKS private API server endpoint is enabled."
  type        = bool
  default     = true
}

variable "public_access_cidrs" {
  description = "List of CIDR blocks that can access the EKS public API server endpoint."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "log_retention_in_days" {
  description = "Number of days to retain logs for EKS, MSK, VPC Flow Logs, and other services."
  type        = number
  default     = 30
}

variable "enable_cloudwatch_agent" {
  description = "Whether to attach the CloudWatch Agent policy to node groups."
  type        = bool
  default     = true
}

variable "enable_xray" {
  description = "Whether to attach the X-Ray Daemon write access policy to node groups."
  type        = bool
  default     = true
}

variable "enable_ssm_access" {
  description = "Whether to attach SSM Managed Instance Core policy to node groups."
  type        = bool
  default     = true
}


