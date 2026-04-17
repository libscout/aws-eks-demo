# ==============================================================================
# Data Sources
# ==============================================================================

# Retrieve current AWS caller identity (account ID, ARN, user ID)
data "aws_caller_identity" "current" {}

# Retrieve current AWS region
data "aws_region" "current" {}

# Retrieve available availability zones for the current region
data "aws_availability_zones" "available" {
  state = "available"
}

# Retrieve ECR authorization token for Docker authentication
data "aws_ecr_authorization_token" "token" {}
