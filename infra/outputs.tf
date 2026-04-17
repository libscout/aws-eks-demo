# ==============================================================================
# Output Values
# ==============================================================================

# VPC Outputs
output "vpc_id" {
  description = "The ID of the VPC."
  value       = module.vpc.vpc_id
}

output "private_subnet_ids" {
  description = "List of IDs of private subnets."
  value       = module.vpc.private_subnets
}

output "public_subnet_ids" {
  description = "List of IDs of public subnets."
  value       = module.vpc.public_subnets
}

# EKS Outputs
output "eks_cluster_id" {
  description = "The name/id of the EKS cluster."
  value       = module.eks.cluster_name
}

output "eks_cluster_endpoint" {
  description = "The endpoint for the EKS cluster API server."
  value       = module.eks.cluster_endpoint
}

output "eks_cluster_certificate_authority_data" {
  description = "Base64 encoded certificate data required to communicate with the cluster."
  value       = module.eks.cluster_certificate_authority_data
}

# RDS Outputs
output "rds_endpoint" {
  description = "The connection endpoint for the RDS PostgreSQL instance."
  value       = module.rds.db_instance_endpoint
}

output "rds_port" {
  description = "The port the RDS PostgreSQL instance is listening on."
  value       = module.rds.db_instance_port
}

# ElastiCache Outputs
output "redis_primary_endpoint_address" {
  description = "The address of the Redis primary endpoint."
  value       = module.elasticache.elasticache_replication_group_primary_endpoint_address
}

output "redis_port" {
  description = "The port the Redis cluster is listening on."
  value       = module.elasticache.elasticache_replication_group_port
}

# MSK Outputs
output "msk_bootstrap_brokers_tls" {
  description = "One or more DNS names (or IP addresses) which TLS Kafka clients can connect to."
  value       = module.msk.bootstrap_brokers_tls
}

output "msk_cluster_arn" {
  description = "The Amazon Resource Name (ARN) of the MSK cluster."
  value       = module.msk.cluster_arn
}

# ECR Outputs
output "ecr_repository_url" {
  description = "The URL of the ECR repository."
  value       = module.ecr.repository_url
}
