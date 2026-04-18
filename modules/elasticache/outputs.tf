output "primary_endpoint_address" {
  description = "The address of the endpoint for the primary node in the replication group."
  value       = aws_elasticache_replication_group.this.primary_endpoint_address
}

output "configuration_endpoint_address" {
  description = "The configuration endpoint address for the replication group."
  value       = aws_elasticache_replication_group.this.configuration_endpoint_address
}

output "arn" {
  description = "The ARN of the ElastiCache replication group."
  value       = aws_elasticache_replication_group.this.arn
}

output "port" {
  description = "The port number on which the cache nodes accept connections."
  value       = aws_elasticache_replication_group.this.port
}

output "subnet_group_name" {
  description = "The name of the ElastiCache subnet group."
  value       = aws_elasticache_subnet_group.this.name
}
