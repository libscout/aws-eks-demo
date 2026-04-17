# AWS EKS Demo - Terraform Infrastructure

This project provides Terraform configurations for deploying and managing an Amazon Elastic Kubernetes Service (EKS) cluster on AWS. It follows infrastructure-as-code best practices for security, maintainability, and team collaboration.

## 📋 Table of Contents

- [Overview](#overview)
- [Prerequisites](#prerequisites)
- [Project Structure](#project-structure)
- [Getting Started](#getting-started)
- [Security Practices](#security-practices)
- [Backend Configuration](#backend-configuration)
- [Usage](#usage)
- [Best Practices](#best-practices)
- [Contributing](#contributing)

## 🎯 Overview

This Terraform project provisions a production-ready EKS cluster with:

- Managed node groups
- VPC and networking infrastructure
- IAM roles and policies (least privilege)
- Security groups and network policies
- Optional add-ons (AWS Load Balancer Controller, EBS CSI Driver, etc.)

## 🔧 Prerequisites

- **Terraform** >= 1.5.0
- **AWS CLI** configured with appropriate credentials
- **kubectl** for cluster interaction
- **AWS Account** with sufficient permissions

### Required IAM Permissions

The following AWS permissions are required:

- `ec2:*` (VPC, subnets, security groups)
- `eks:*` (EKS cluster management)
- `iam:*` (IAM roles and policies)
- `s3:*` (Remote state backend)
- `sts:AssumeRole` (If using role assumption)

## 📁 Project Structure

```
aws-eks-demo/
├── README.md              # Project documentation
├── main.tf                # Main infrastructure resources
├── variables.tf           # Input variable definitions
├── outputs.tf             # Output values
├── versions.tf            # Terraform and provider version constraints
├── locals.tf              # Local values and transformations
├── data.tf                # Data source definitions
├── .terraform.lock.hcl    # Provider dependency lock file
├── modules/               # Reusable Terraform modules
│   └── ...
└── environments/          # Environment-specific configurations (optional)
    ├── dev/
    ├── staging/
    └── prod/
```

## 🚀 Getting Started

### 1. Clone the Repository

```bash
git clone <repository-url>
cd aws-eks-demo
```

### 2. Configure Backend

Create a backend configuration file or use the default S3 backend:

```hcl
# backend.tf
terraform {
  backend "s3" {
    bucket         = "your-terraform-state-bucket"
    key            = "eks-demo/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-locks"
  }
}
```

### 3. Initialize Terraform

```bash
terraform init
```

### 4. Plan and Apply

```bash
# Review changes
terraform plan -var-file="environments/dev.tfvars"

# Apply changes
terraform apply -var-file="environments/dev.tfvars"
```

## 🔒 Security Practices

This project follows security best practices:

- **Least Privilege**: IAM roles and policies grant only necessary permissions
- **IAM Roles Over Users**: Prefer roles with temporary credentials
- **No Hardcoded Secrets**: Use AWS Secrets Manager or SSM Parameter Store
- **Sensitive Outputs**: Mark sensitive data with `sensitive = true`
- **State Encryption**: Remote state is encrypted at rest
- **State Locking**: DynamoDB table prevents concurrent state modifications
- **OIDC Integration**: Support for CI/CD short-lived credentials

### Credential Management

For local development:

```bash
# Use AWS SSO or assume-role
aws sso login
# or
aws sts assume-role --role-arn arn:aws:iam::ACCOUNT:role/terraform-role
```

For CI/CD:

- Configure OIDC provider for GitHub Actions, GitLab CI, etc.
- Use short-lived tokens instead of long-lived access keys

## 🗄️ Backend Configuration

### S3 Backend Setup

```bash
# Create S3 bucket for state
aws s3api create-bucket --bucket your-terraform-state-bucket --region us-east-1

# Enable versioning
aws s3api put-bucket-versioning \
  --bucket your-terraform-state-bucket \
  --versioning-configuration Status=Enabled

# Enable encryption
aws s3api put-bucket-encryption \
  --bucket your-terraform-state-bucket \
  --server-side-encryption-configuration '{"Rules":[{"ApplyServerSideEncryptionByDefault":{"SSEAlgorithm":"aws:kms"}}]}'

# Create DynamoDB table for locking
aws dynamodb create-table \
  --table-name terraform-locks \
  --attribute-definitions AttributeName=LockID,AttributeType=S \
  --key-schema AttributeName=LockID,KeyType=HASH \
  --billing-mode PAY_PER_REQUEST \
  --region us-east-1
```

### Environment Separation

Maintain separate state files per environment:

- `dev/terraform.tfstate`
- `staging/terraform.tfstate`
- `prod/terraform.tfstate`

## 📖 Usage

### Variable Files

Create environment-specific variable files:

```hcl
# environments/dev.tfvars
environment      = "dev"
cluster_name     = "eks-demo-dev"
region           = "us-east-1"
instance_types   = ["t3.medium"]
desired_capacity = 2
max_capacity     = 4
min_capacity     = 1
```

### Common Commands

```bash
# Initialize
terraform init

# Format code
terraform fmt -recursive

# Validate configuration
terraform validate

# Plan changes
terraform plan -var-file="environments/dev.tfvars"

# Apply changes
terraform apply -var-file="environments/dev.tfvars"

# Destroy infrastructure
terraform destroy -var-file="environments/dev.tfvars"

# View outputs
terraform output
```

## ✅ Best Practices

### Provider Version Management

- Provider versions are pinned in `versions.tf`
- Use `.terraform.lock.hcl` for reproducible builds
- Test upgrades in non-production first

### Module Design

- Use community modules from trusted sources (e.g., `terraform-aws-modules`)
- Prefer composable modules over deeply nested structures
- Customize through input variables, not internal edits
- Follow Terraform Registry conventions

### Code Quality

- Run `terraform fmt` before committing
- Use `terraform validate` in CI/CD pipelines
- Implement TFLint with AWS provider rulesets
- Add descriptive comments to variables and outputs

### Tagging Strategy

Apply consistent tags across all resources:

```hcl
default_tags {
  tags = {
    Environment = var.environment
    ManagedBy   = "terraform"
    Project     = "eks-demo"
    Owner       = "platform-team"
  }
}
```

## 🤝 Contributing

1. Create a feature branch
2. Make changes and test locally
3. Run `terraform fmt` and `terraform validate`
4. Submit a pull request with detailed description
5. Review and approve before merging

### Pre-commit Checklist

- [ ] Code formatted with `terraform fmt`
- [ ] Configuration validated with `terraform validate`
- [ ] Variables and outputs documented
- [ ] Sensitive values marked appropriately
- [ ] Tests pass (if applicable)
- [ ] README updated if needed

## 📚 Resources

- [Terraform AWS Provider Documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [AWS EKS Best Practices](https://aws.github.io/aws-eks-best-practices/)
- [Terraform AWS Modules](https://registry.terraform.io/modules/terraform-aws-modules)
- [Terraform Security Best Practices](https://developer.hashicorp.com/terraform/cloud-docs/recommended-practices/part1)

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.
