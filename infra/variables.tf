# General Configuration
variable "region" {
  description = "The AWS region to deploy resources into."
  type        = string
  nullable    = false
  # default     = "us-east-1"
}

variable "environment" {
  description = "The deployment environment (e.g., dev, staging, prod)."
  type        = string
  nullable    = false
}

# VPC Configuration
variable "vpc_cidr" {
  description = "The CIDR block for the VPC."
  type        = string
  nullable    = false
  # default     = "10.0.0.0/16"
}

variable "availability_zones" {
  description = "List of availability zones to use for subnets."
  type        = list(string)
  nullable    = false
  # default     = ["us-east-1a", "us-east-1b"]
}

# EKS Configuration
variable "cluster_name" {
  description = "The name of the EKS cluster."
  nullable    = false
  type        = string
}

variable "cluster_version" {
  description = "The Kubernetes version for the EKS cluster."
  type        = string
  nullable    = false
  # default     = "1.35"
}

variable "node_instance_types" {
  description = "List of EC2 instance types for the EKS managed node group."
  type        = list(string)
  nullable    = false
  # default     = ["t4g.nano"]
}

variable "node_desired_capacity" {
  description = "Desired number of worker nodes."
  type        = number
  # default     = 2
}

variable "node_max_capacity" {
  description = "Maximum number of worker nodes."
  type        = number
  nullable    = false
}

variable "node_min_capacity" {
  description = "Minimum number of worker nodes."
  type        = number
  nullable    = false
}

# RDS Configuration
variable "db_instance_class" {
  description = "The RDS instance type."
  type        = string
  nullable    = false
  # default     = "db.t3.medium"
}

variable "db_allocated_storage" {
  description = "The allocated storage in gigabytes for the RDS instance."
  type        = number
  nullable    = false
}

variable "db_username" {
  description = "The master username for the RDS instance."
  type        = string
  nullable    = false
  sensitive   = true
}

variable "db_password" {
  description = "The master password for the RDS instance."
  type        = string
  nullable    = false
  sensitive   = true
}

# ElastiCache Configuration
variable "redis_node_type" {
  description = "The instance type for the ElastiCache Redis cluster."
  type        = string
  nullable    = false
  # default     = "cache.t3.micro"
}

variable "redis_num_cache_nodes" {
  description = "The number of cache nodes in the Redis cluster."
  type        = number
  nullable    = false
}

# MSK Configuration
variable "msk_broker_instance_type" {
  description = "The instance type for MSK brokers."
  type        = string
  nullable    = false
  # default     = "kafka.t3.small"
}

variable "msk_number_of_broker_nodes" {
  description = "The number of broker nodes in the MSK cluster."
  type        = number
  nullable    = false
}

# Tags
variable "additional_tags" {
  description = "Additional tags to apply to all resources."
  type        = map(string)
  default     = {}
}
