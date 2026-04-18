variable "cluster_id" {
  description = "The ID of the ElastiCache cluster"
  type        = string
  nullable    = false
}

variable "description" {
  description = "Description for the ElastiCache cluster"
  type        = string
  nullable    = false
}

variable "engine" {
  description = "The name of the cache engine to use"
  type        = string
  default     = "redis"
  nullable    = false
}

variable "engine_version" {
  description = "The version number of the cache engine"
  type        = string
  nullable    = false
}

variable "node_type" {
  description = "The compute and memory capacity of the nodes in the node group"
  type        = string
  nullable    = false
}

variable "num_cache_nodes" {
  description = "The initial number of cache nodes that the cache cluster will have"
  type        = number
  default     = 1
  nullable    = false
}

variable "port" {
  description = "The port number on which each of the cache nodes will accept connections"
  type        = number
  default     = 6379
  nullable    = false
}

variable "apply_immediately" {
  description = "Specifies whether any modifications are applied immediately, or during the next maintenance window"
  type        = bool
  default     = true
  nullable    = false
}

variable "subnet_ids" {
  description = "A list of VPC subnet IDs to apply to the ElastiCache subnet group"
  type        = list(string)
  nullable    = false
}

variable "security_group_ids" {
  description = "List of VPC security groups to associate with the cluster"
  type        = list(string)
  nullable    = false
}

variable "transit_encryption_enabled" {
  description = "Enable encryption in transit"
  type        = bool
  default     = true
  nullable    = false
}

variable "at_rest_encryption_enabled" {
  description = "Enable encryption at rest"
  type        = bool
  default     = true
  nullable    = false
}

variable "kms_key_id" {
  description = "The ARN of the KMS key used to encrypt the cache cluster at rest"
  type        = string
  default     = null
}

variable "automatic_failover_enabled" {
  description = "Enable automatic failover for the cluster"
  type        = bool
  default     = false
  nullable    = false
}

variable "multi_az_enabled" {
  description = "Enable Multi-AZ support for automatic failover"
  type        = bool
  default     = false
  nullable    = false
}

variable "snapshot_retention_limit" {
  description = "The number of days for which ElastiCache retains automatic snapshots before deleting them"
  type        = number
  default     = 0
  nullable    = false
}

variable "snapshot_window" {
  description = "The daily time range (in UTC) during which ElastiCache will begin taking a daily snapshot of your cache cluster"
  type        = string
  default     = null
}

variable "maintenance_window" {
  description = "The weekly time range (in UTC) during which maintenance can occur"
  type        = string
  default     = null
}

variable "tags" {
  description = "A mapping of tags to assign to all resources"
  type        = map(string)
  default     = {}
  nullable    = false
}
