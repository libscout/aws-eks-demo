# General Configuration
variable "region" {
  description = "The AWS region to deploy resources into."
  type        = string
  default     = "us-east-1"
}

# VPC Configuration
variable "vpc_cidr" {
  description = "The CIDR block for the VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  description = "List of availability zones to use for subnets."
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

# EKS Configuration
variable "cluster_name" {
  description = "The name of the EKS cluster."
  type        = string
}

variable "cluster_version" {
  description = "The Kubernetes version for the EKS cluster."
  type        = string
  default     = "1.28"
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
  default     = 4
}

variable "node_min_capacity" {
  description = "Minimum number of worker nodes."
  type        = number
  default     = 1
}

# RDS Configuration
variable "db_instance_class" {
  description = "The RDS instance type."
  type        = string
  default     = "db.t3.medium"
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

variable "db_password" {
  description = "The master password for the RDS instance."
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
  description = "Number of days to retain EKS CloudWatch logs."
  type        = number
  default     = 30
}

variable "encryption_resources" {
  description = "List of Kubernetes resources to encrypt using the KMS key."
  type        = list(string)
  default     = ["secrets"]
}

variable "enable_cloudwatch_agent" {
  description = "Whether to attach the CloudWatch Agent policy to node groups."
  type        = bool
  default     = false
}

variable "enable_xray" {
  description = "Whether to attach the X-Ray Daemon write access policy to node groups."
  type        = bool
  default     = false
}

variable "enable_ssm_access" {
  description = "Whether to attach SSM Managed Instance Core policy to node groups."
  type        = bool
  default     = false
}

variable "alarm_actions" {
  description = "List of ARNs for SNS topics to trigger when CloudWatch alarms are in ALARM state."
  type        = list(string)
  default     = []
}

# Tags
variable "additional_tags" {
  description = "Additional tags to apply to all resources."
  type        = map(string)
  default     = {}
}
