terraform {
  required_version = ">= 1.14.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.0"
    }
  }

  # Remote backend configuration
  # Uncomment and configure for production use:
  # backend "s3" {
  #   bucket         = "your-terraform-state-bucket"
  #   key            = "eks-demo/terraform.tfstate"
  #   region         = "us-east-1"
  #   encrypt        = true
  #   dynamodb_table = "terraform-locks"
  # }
}

provider "aws" {
  region = var.region

  default_tags {
    tags = {
      Environment = local.env
      ManagedBy   = "terraform"
      Project     = "eks-demo"
    }
  }
}
