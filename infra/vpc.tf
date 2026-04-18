# ==============================================================================
# VPC and Networking
# ==============================================================================

module "vpc" {
  source = "../modules/vpc"

  name                 = "${var.cluster_name}-vpc"
  cidr                 = var.vpc_cidr
  availability_zones   = var.availability_zones
  private_subnet_cidrs = [for i, az in var.availability_zones : cidrsubnet(var.vpc_cidr, 8, i)]
  public_subnet_cidrs  = [for i, az in var.availability_zones : cidrsubnet(var.vpc_cidr, 8, i + length(var.availability_zones))]

  cluster_name            = var.cluster_name
  enable_nat_gateway      = true
  flow_log_retention_days = var.environment == "prod" ? 90 : 30

  tags = merge(var.additional_tags, {
    Name = "${var.cluster_name}-vpc"
  })
}
