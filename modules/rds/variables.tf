variable "identifier" {
  description = "The name of the RDS instance"
  type        = string
  nullable    = false
}

variable "engine" {
  description = "The database engine to use"
  type        = string
  nullable    = false
}

variable "engine_version" {
  description = "The engine version to use"
  type        = string
  nullable    = false
}

variable "instance_class" {
  description = "The instance type of the RDS instance"
  type        = string
  nullable    = false
}

variable "allocated_storage" {
  description = "The allocated storage in gigabytes"
  type        = number
  nullable    = false
}

variable "db_name" {
  description = "The name of the database to create when the DB instance is created"
  type        = string
  nullable    = false
}

variable "username" {
  description = "Username for the master DB user"
  type        = string
  sensitive   = true
  nullable    = false
}

variable "master_user_secret_kms_key_id" {
  description = "The KMS key ID used to encrypt the managed secret. Required when manage_master_user_password is true."
  type        = string
  nullable    = false
}

variable "port" {
  description = "The port on which the DB accepts connections"
  type        = number
  default     = 5432
}

variable "subnet_ids" {
  description = "A list of VPC subnet IDs to apply to the DB subnet group"
  type        = list(string)
  nullable    = false
}

variable "vpc_security_group_ids" {
  description = "List of VPC security groups to associate"
  type        = list(string)
  nullable    = false
}

variable "storage_encrypted" {
  description = "Specifies whether the DB instance is encrypted"
  type        = bool
  default     = true
}

variable "kms_key_id" {
  description = "The ARN for the KMS encryption key. If creating an encrypted replica, set this to the destination KMS ARN"
  type        = string
  nullable    = false
}

variable "multi_az" {
  description = "Specifies if the RDS instance is multi-AZ"
  type        = bool
  default     = false
}

variable "skip_final_snapshot" {
  description = "Determines if a final DB snapshot is created before the DB instance is deleted"
  type        = bool
  default     = true
}

variable "deletion_protection" {
  description = "If the DB instance should have deletion protection enabled"
  type        = bool
  default     = false
}

variable "backup_retention_period" {
  description = "The days to retain backups for"
  type        = number
  default     = 1
}

variable "storage_type" {
  description = "The storage type to use (e.g., gp2, gp3, io1, standard)"
  type        = string
  nullable    = false
}

variable "publicly_accessible" {
  description = "Specifies if the RDS instance is publicly accessible"
  type        = bool
  default     = false
}

variable "backup_window" {
  description = "The daily time range during which automated backups are created"
  type        = string
  default     = "03:00-04:00"
}

variable "maintenance_window" {
  description = "The window to perform maintenance in"
  type        = string
  default     = "Mon:04:00-Mon:05:00"
}

variable "tags" {
  description = "A mapping of tags to assign to all resources"
  type        = map(string)
  default     = {}
}
