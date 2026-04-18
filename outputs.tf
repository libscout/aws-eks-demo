# ==============================================================================
# Output Values
# ==============================================================================

# VPC Outputs
output "vpc_id" {
  description = "The ID of the VPC."
  value       = module.infra.vpc_id
}

output "private_subnet_ids" {
  description = "List of IDs of private subnets."
  value       = module.infra.private_subnet_ids
}

output "public_subnet_ids" {
  description = "List of IDs of public subnets."
  value       = module.infra.public_subnet_ids
}

# EKS Outputs
output "eks_cluster_id" {
  description = "The name/id of the EKS cluster."
  value       = module.infra.eks_cluster_id
}

output "eks_cluster_endpoint" {
  description = "The endpoint for the EKS cluster API server."
  value       = module.infra.eks_cluster_endpoint
}

output "eks_ca_cert" {
  description = "Base64 encoded certificate data required to communicate with the cluster."
  value       = module.infra.eks_ca_cert
}

# RDS Outputs
output "rds_endpoint" {
  description = "The connection endpoint for the RDS PostgreSQL instance."
  value       = module.infra.rds_endpoint
}

output "rds_port" {
  description = "The port the RDS PostgreSQL instance is listening on."
  value       = module.infra.rds_port
}

# ElastiCache Outputs
output "redis_endpoint" {
  description = "The address of the Redis primary endpoint."
  value       = module.infra.redis_endpoint
}

output "redis_port" {
  description = "The port the Redis cluster is listening on."
  value       = module.infra.redis_port
}

# MSK Outputs
output "msk_brokers_tls" {
  description = "One or more DNS names (or IP addresses) which TLS Kafka clients can connect to."
  value       = module.infra.msk_brokers_tls
}

output "msk_cluster_arn" {
  description = "The Amazon Resource Name (ARN) of the MSK cluster."
  value       = module.infra.msk_cluster_arn
}

# ECR Outputs
output "ecr_repository_url" {
  description = "The URL of the ECR repository."
  value       = module.infra.ecr_repository_url
}
