# ==============================================================================
# Required Variables
# ==============================================================================

variable "cluster_name" {
  description = "The name of the EKS cluster. Must be unique within the AWS account and region."
  type        = string
  nullable    = false

  validation {
    condition     = can(regex("^[a-zA-Z][a-zA-Z0-9-]{1,99}$", var.cluster_name))
    error_message = "Cluster name must start with a letter, contain only alphanumeric characters and hyphens, and be 1-100 characters long."
  }
}

variable "vpc_id" {
  description = "The ID of the VPC where the EKS cluster and node groups will be deployed."
  type        = string
  nullable    = false
}

variable "subnet_ids" {
  description = "List of subnet IDs where the EKS cluster and node groups will be deployed. Should include both public and private subnets across multiple AZs."
  type        = list(string)
  nullable    = false

  validation {
    condition     = length(var.subnet_ids) >= 2
    error_message = "At least 2 subnets are required for high availability."
  }
}

variable "subnet_cidrs" {
  description = "List of CIDR blocks for the subnets where the EKS cluster and node groups will be deployed. Used for security group rules."
  type        = list(string)
  nullable    = false

  validation {
    condition     = length(var.subnet_cidrs) >= 2
    error_message = "At least 2 subnet CIDRs are required for high availability."
  }
}

# ==============================================================================
# Cluster Configuration
# ==============================================================================

variable "cluster_version" {
  description = "The Kubernetes version for the EKS cluster (e.g., '1.28', '1.29')."
  type        = string
  nullable    = false
}

variable "endpoint_public_access" {
  description = "Indicates whether or not the Amazon EKS public API server endpoint is enabled."
  type        = bool
  nullable    = false
}

variable "endpoint_private_access" {
  description = "Indicates whether or not the Amazon EKS private API server endpoint is enabled."
  type        = bool
  nullable    = false
}

variable "public_access_cidrs" {
  description = "List of CIDR blocks that can access the Amazon EKS public API server endpoint. Leave empty to allow all (0.0.0.0/0)."
  type        = list(string)
  nullable    = false
  # default     = ["0.0.0.0/0"]
}

# ==============================================================================
# Logging Configuration
# ==============================================================================

variable "enabled_cluster_log_types" {
  description = "List of the desired control plane logging types to enable for the EKS cluster. Valid values: api, audit, authenticator, controllerManager, scheduler."
  type        = list(string)
  nullable    = false
  default     = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
}

variable "log_retention_in_days" {
  description = "Number of days to retain CloudWatch logs for the EKS cluster."
  type        = number
  nullable    = false

  validation {
    condition     = contains([1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1827, 3653], var.log_retention_in_days)
    error_message = "Log retention must be one of the valid CloudWatch retention periods: 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1827, or 3653."
  }
}

# ==============================================================================
# Encryption Configuration
# ==============================================================================

variable "kms_key_arn" {
  description = "ARN of an existing KMS key to use for encrypting Kubernetes secrets. If not provided, a new key will be created."
  type        = string
}

variable "encryption_resources" {
  description = "List of Kubernetes resources to encrypt using the KMS key."
  type        = list(string)
  nullable    = false
  # default     = ["secrets"]
}

# ==============================================================================
# Node Groups Configuration
# ==============================================================================

variable "node_groups" {
  description = "Map of EKS managed node group configurations. Each key is the node group name."
  type = map(object({
    instance_types = list(string)
    min_size       = number
    max_size       = number
    desired_size   = number
    capacity_type  = optional(string, "ON_DEMAND")
    ami_type       = optional(string, "AL2_x86_64")
    disk_size      = optional(number, 20)
    disk_type      = optional(string, "gp3")
    subnet_ids     = optional(list(string), null)
    labels         = optional(map(string), {})
    taints = optional(list(object({
      key    = string
      value  = string
      effect = string
    })), [])
  }))

  validation {
    condition = alltrue([
      for ng in values(var.node_groups) : ng.min_size <= ng.desired_size && ng.desired_size <= ng.max_size
    ])
    error_message = "For each node group, min_size must be <= desired_size <= max_size."
  }
}

# ==============================================================================
# Optional Features
# ==============================================================================

variable "enable_cloudwatch_agent" {
  description = "Whether to attach the CloudWatch Agent policy to node groups for enhanced monitoring."
  type        = bool
  nullable    = false
}

variable "enable_xray" {
  description = "Whether to attach the X-Ray Daemon write access policy to node groups."
  type        = bool
  nullable    = false
}

variable "enable_ssm_access" {
  description = "Whether to attach SSM Managed Instance Core policy to node groups for secure shell access without SSH keys."
  type        = bool
  nullable    = false
}

# ==============================================================================
# Monitoring & Alerts
# ==============================================================================

variable "alarm_actions" {
  description = "List of ARNs for SNS topics or other actions to trigger when CloudWatch alarms are in the ALARM state."
  type        = list(string)
  nullable    = false
}

# ==============================================================================
# Tags
# ==============================================================================

variable "tags" {
  description = "A map of tags to add to all resources created by this module."
  type        = map(string)
  nullable    = false
}
