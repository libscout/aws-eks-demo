# ==============================================================================
# EKS Cluster
# ==============================================================================

resource "aws_eks_cluster" "this" {
  name     = var.cluster_name
  role_arn = aws_iam_role.cluster.arn
  version  = var.cluster_version

  vpc_config {
    subnet_ids              = var.subnet_ids
    endpoint_private_access = var.endpoint_private_access
    endpoint_public_access  = var.endpoint_public_access
    public_access_cidrs     = var.public_access_cidrs
    security_group_ids      = [aws_security_group.cluster.id]
  }

  # Cluster logging configuration
  enabled_cluster_log_types = var.enabled_cluster_log_types

  # Encryption configuration
  encryption_config {
    resources = var.encryption_resources
    provider {
      key_arn = var.kms_key_arn
    }
  }

  tags = merge(var.tags, {
    Name = var.cluster_name
  })

  depends_on = [
    aws_iam_role_policy_attachment.cluster,
    aws_cloudwatch_log_group.this,
  ]
}
