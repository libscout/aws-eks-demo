variable "cluster_name" {
  description = "Name of the MSK cluster"
  type        = string
}

variable "kafka_version" {
  description = "Specify the Apache Kafka version to use"
  type        = string
}

variable "number_of_broker_nodes" {
  description = "The desired total number of broker nodes in the cluster"
  type        = number
}

variable "broker_node_instance_type" {
  description = "Specify the instance type to use for the kafka brokers"
  type        = string
}

variable "broker_node_ebs_volume_size" {
  description = "The size in GiB of the EBS volume for the data drive on each broker node"
  type        = number
  default     = 100
}

variable "broker_node_client_subnets" {
  description = "A list of subnets to connect to in client VPC"
  type        = list(string)
}

variable "broker_node_security_groups" {
  description = "The security groups to attach to the ENIs of the broker nodes"
  type        = list(string)
}

variable "encryption_in_transit_client_broker" {
  description = "Encryption setting for data in transit between client and broker. Valid values: TLS, TLS_PLAINTEXT, PLAINTEXT"
  type        = string
  default     = "TLS"
}

variable "encryption_at_rest_kms_key_arn" {
  description = "You may specify a KMS key short ID or ARN to encrypt data at rest"
  type        = string
  default     = null
}

variable "logging_enabled" {
  description = "Enable CloudWatch logging for the cluster"
  type        = bool
  default     = true
}

variable "cloudwatch_log_group_name" {
  description = "Name of the CloudWatch log group to which logs are published"
  type        = string
  default     = null
}

variable "cloudwatch_log_group_retention_in_days" {
  description = "Number of days to retain CloudWatch logs"
  type        = number
  default     = 30
}

variable "monitoring_level" {
  description = "Specify the level of monitoring for the MSK cluster. Valid values: DEFAULT, PER_BROKER, PER_TOPIC_PER_BROKER, PER_TOPIC_PER_PARTITION"
  type        = string
  default     = "DEFAULT"
}

variable "storage_mode" {
  description = "The storage mode for the MSK cluster. Valid values: LOCAL, TIERED"
  type        = string
  default     = "LOCAL"
}

variable "tags" {
  description = "A mapping of tags to assign to all resources"
  type        = map(string)
  default     = {}
}
