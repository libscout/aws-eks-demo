# ==============================================================================
# Local Values and Transformations
# ==============================================================================

locals {
  # Common tags applied to all resources
  common_tags = merge(
    var.additional_tags,
    {
      Environment = var.environment
      ManagedBy   = "terraform"
      Project     = "eks-demo"
      Name        = var.cluster_name
    }
  )

  # Naming prefixes for resources
  name_prefix = var.cluster_name

  # Network configuration
  private_subnet_cidrs = [for i, az in var.availability_zones : cidrsubnet(var.vpc_cidr, 8, i)]
  public_subnet_cidrs  = [for i, az in var.availability_zones : cidrsubnet(var.vpc_cidr, 8, i + length(var.availability_zones))]

  # Environment-specific settings
  is_production = var.environment == "prod"

  # Database configuration
  db_name = "appdb"

  # Redis configuration
  redis_port = 6379

  # Kafka configuration
  kafka_port = 9094
}
