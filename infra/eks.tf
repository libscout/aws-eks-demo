# ==============================================================================
# EKS Cluster & Node Groups
# ==============================================================================

module "eks" {
  source = "../modules/eks"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version

  vpc_id       = module.vpc.vpc_id
  subnet_ids   = module.vpc.private_subnets
  subnet_cidrs = [for i, az in var.availability_zones : cidrsubnet(var.vpc_cidr, 8, i)]

  endpoint_public_access  = var.endpoint_public_access
  endpoint_private_access = var.endpoint_private_access
  public_access_cidrs     = var.public_access_cidrs

  enabled_cluster_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
  log_retention_in_days     = var.log_retention_in_days

  encryption_resources = var.encryption_resources

  node_groups = {
    default = {
      instance_types = var.node_instance_types
      min_size       = var.node_min_capacity
      max_size       = var.node_max_capacity
      desired_size   = var.node_desired_capacity
    }
  }

  enable_cloudwatch_agent = var.enable_cloudwatch_agent
  enable_xray             = var.enable_xray
  enable_ssm_access       = var.enable_ssm_access
  alarm_actions           = var.alarm_actions

  tags = merge(var.additional_tags, {
    Name = var.cluster_name
  })
}
