# ==============================================================================
# VPC and Networking
# ==============================================================================

module "vpc" {
  source = "../modules/vpc"

  name                 = "${var.cluster_name}-vpc"
  cluster_name         = var.cluster_name
  cidr                 = var.vpc_cidr
  availability_zones   = var.availability_zones
  private_subnet_cidrs = [for i, az in var.availability_zones : cidrsubnet(var.vpc_cidr, 8, i)]
  public_subnet_cidrs  = [for i, az in var.availability_zones : cidrsubnet(var.vpc_cidr, 8, i + length(var.availability_zones))]

  enable_nat_gateway      = true
  flow_log_retention_days = var.log_retention_in_days

  tags = merge(var.additional_tags, {
    Name = "${var.cluster_name}-vpc"
  })
}
