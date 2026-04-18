# ==============================================================================
# Output Values
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

output "ca_cert" {
  description = "Base64 encoded certificate data required to communicate with the cluster."
  value       = aws_eks_cluster.this.certificate_authority[0].data
}

output "cluster_version" {
  description = "The Kubernetes version for the EKS cluster."
  value       = aws_eks_cluster.this.version
}

output "cluster_sg_id" {
  description = "Security group ID attached to the EKS cluster."
  value       = aws_security_group.cluster.id
}

output "node_sg_id" {
  description = "Security group ID attached to the EKS node groups."
  value       = aws_security_group.node.id
}
