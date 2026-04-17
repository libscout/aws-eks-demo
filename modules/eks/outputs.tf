# ==============================================================================
# EKS Cluster Outputs
# ==============================================================================

output "cluster_id" {
  description = "The ID of the EKS cluster."
  value       = aws_eks_cluster.this.id
}

output "cluster_name" {
  description = "The name of the EKS cluster."
  value       = aws_eks_cluster.this.name
}

output "cluster_endpoint" {
  description = "The endpoint for the EKS cluster API server."
  value       = aws_eks_cluster.this.endpoint
}

output "cluster_certificate_authority_data" {
  description = "Base64 encoded certificate data required to communicate with the cluster."
  value       = aws_eks_cluster.this.certificate_authority[0].data
}

output "cluster_version" {
  description = "The Kubernetes version for the EKS cluster."
  value       = aws_eks_cluster.this.version
}

# ==============================================================================
# Security Groups
# ==============================================================================

output "cluster_security_group_id" {
  description = "Security group ID attached to the EKS cluster."
  value       = aws_security_group.cluster.id
}

output "node_security_group_id" {
  description = "Security group ID attached to the EKS node groups."
  value       = aws_security_group.node.id
}

# ==============================================================================
# IAM & OIDC
# ==============================================================================

output "oidc_provider_arn" {
  description = "The ARN of the OIDC Provider if `enable_irsa` is true."
  value       = aws_iam_openid_connect_provider.eks.arn
}

output "oidc_provider_url" {
  description = "The URL of the OIDC Provider."
  value       = aws_iam_openid_connect_provider.eks.url
}

output "node_iam_role_arn" {
  description = "The ARN of the IAM role used by the node groups."
  value       = aws_iam_role.node.arn
}

output "node_iam_role_name" {
  description = "The name of the IAM role used by the node groups."
  value       = aws_iam_role.node.name
}

# ==============================================================================
# Encryption & Logging
# ==============================================================================

output "kms_key_arn" {
  description = "The ARN of the KMS key used to encrypt the EKS cluster secrets."
  value       = var.kms_key_arn != null ? var.kms_key_arn : aws_kms_key.cluster[0].arn
}

output "cloudwatch_log_group_name" {
  description = "Name of the CloudWatch Log Group for EKS cluster logs."
  value       = aws_cloudwatch_log_group.this.name
}

# ==============================================================================
# Node Groups
# ==============================================================================

output "node_group_names" {
  description = "List of the EKS managed node group names."
  value       = [for ng in aws_eks_node_group.this : ng.node_group_name]
}

output "node_group_arns" {
  description = "List of the ARNs of the EKS managed node groups."
  value       = [for ng in aws_eks_node_group.this : ng.arn]
}
