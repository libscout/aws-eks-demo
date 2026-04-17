# ==============================================================================
# EKS Cluster & Node Groups
# ==============================================================================

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "21.18.0"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  cluster_endpoint_public_access  = true
  cluster_endpoint_private_access = true

  # Enable IRSA for pod-level permissions
  enable_irsa = true

  # Cluster logging
  cluster_enabled_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]

  eks_managed_node_groups = {
    default = {
      instance_types = var.node_instance_types
      min_size       = var.node_min_capacity
      max_size       = var.node_max_capacity
      desired_size   = var.node_desired_capacity

      # Enable IMDSv2
      metadata_options = {
        http_endpoint = "enabled"
        http_tokens   = "required"
      }
    }
  }

  tags = merge(var.additional_tags, {
    Name = var.cluster_name
  })
}
