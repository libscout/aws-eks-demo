# AWS EKS Terraform Module

A production-ready, secure, and highly configurable Terraform module for provisioning Amazon Elastic Kubernetes Service (EKS) clusters with managed node groups.

## Features

- **EKS Cluster**: Fully managed Kubernetes control plane with configurable versions and logging
- **Managed Node Groups**: Auto-scaling worker nodes with launch templates and IMDSv2 enforcement
- **Security**: 
  - IRSA (IAM Roles for Service Accounts) enabled by default
  - KMS encryption for Kubernetes secrets
  - Dedicated security groups for cluster and nodes
  - Least-privilege IAM roles and policies
- **Monitoring**: Built-in CloudWatch alarms for CPU, memory, status checks, and API errors
- **Logging**: Comprehensive control plane logging to CloudWatch Logs
- **Compliance**: Follows AWS and Terraform best practices for security and reliability

## Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                          VPC                                 │
│  ┌───────────────────────────────────────────────────────┐  │
│  │              EKS Cluster Control Plane                 │  │
│  │  • API Server (Public/Private Endpoints)              │  │
│  │  • KMS Encryption                                     │  │
│  │  • CloudWatch Logs                                    │  │
│  └──────────────────────┬────────────────────────────────┘  │
│                         │                                    │
│  ┌──────────────────────▼────────────────────────────────┐  │
│  │           Managed Node Groups (ASG)                   │  │
│  │  • Launch Templates (IMDSv2, EBS encryption)         │  │
│  │  • Security Groups (restricted ingress/egress)       │  │
│  │  • IAM Roles (IRSA, SSM, CloudWatch)                 │  │
│  └───────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
```

## Usage

### Basic Example

```hcl
module "eks" {
  source = "./modules/eks"

  cluster_name    = "my-eks-cluster"
  cluster_version = "1.28"
  vpc_id          = module.vpc.vpc_id
  subnet_ids      = module.vpc.private_subnets

  node_groups = {
    default = {
      instance_types = ["t3.medium"]
      min_size       = 1
      max_size       = 4
      desired_size   = 2
    }
  }

  tags = {
    Environment = "production"
    Project     = "api-platform"
  }
}
```

### Advanced Example with Multiple Node Groups

```hcl
module "eks" {
  source = "./modules/eks"

  cluster_name    = "production-eks"
  cluster_version = "1.29"
  vpc_id          = module.vpc.vpc_id
  subnet_ids      = module.vpc.private_subnets

  # Restrict public API access to specific CIDRs
  endpoint_public_access  = true
  endpoint_private_access = true
  public_access_cidrs     = ["10.0.0.0/8"]

  # Enable all control plane logs
  enabled_cluster_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
  log_retention_in_days     = 90

  # Use existing KMS key
  kms_key_arn = aws_kms_key.eks.arn

  node_groups = {
    general = {
      instance_types = ["t3.medium"]
      min_size       = 2
      max_size       = 6
      desired_size   = 3
      disk_size      = 50
      disk_type      = "gp3"
      labels = {
        workload = "general"
      }
    }

    compute_optimized = {
      instance_types = ["c6i.xlarge"]
      min_size       = 1
      max_size       = 10
      desired_size   = 2
      capacity_type  = "SPOT"
      ami_type       = "AL2_x86_64"
      disk_size      = 100
      labels = {
        workload = "compute-intensive"
      }
      taints = [
        {
          key    = "dedicated"
          value  = "compute"
          effect = "NO_SCHEDULE"
        }
      ]
    }
  }

  # Enable additional features
  enable_cloudwatch_agent = true
  enable_xray             = true
  enable_ssm_access       = true

  # CloudWatch alarm notifications
  alarm_actions = [aws_sns_topic.infra_alerts.arn]

  tags = {
    Environment = "production"
    ManagedBy   = "terraform"
  }
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.5.0 |
| aws | >= 5.0, < 7.0 |
| tls | >= 4.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| cluster_name | The name of the EKS cluster. Must be unique within the AWS account and region. | `string` | n/a | yes |
| vpc_id | The ID of the VPC where the EKS cluster and node groups will be deployed. | `string` | n/a | yes |
| subnet_ids | List of subnet IDs for cluster and node groups. Should span multiple AZs. | `list(string)` | n/a | yes |
| node_groups | Map of managed node group configurations. | `map(object({...}))` | n/a | yes |
| cluster_version | Kubernetes version for the EKS cluster (e.g., '1.28', '1.29'). | `string` | `"1.28"` | no |
| endpoint_public_access | Enable public API server endpoint. | `bool` | `true` | no |
| endpoint_private_access | Enable private API server endpoint. | `bool` | `true` | no |
| public_access_cidrs | CIDR blocks allowed to access public API endpoint. | `list(string)` | `["0.0.0.0/0"]` | no |
| enabled_cluster_log_types | Control plane log types to enable. | `list(string)` | `["api", "audit", "authenticator", "controllerManager", "scheduler"]` | no |
| log_retention_in_days | CloudWatch log retention period in days. | `number` | `30` | no |
| kms_key_arn | ARN of existing KMS key for secret encryption. Creates new key if null. | `string` | `null` | no |
| encryption_resources | Kubernetes resources to encrypt. | `list(string)` | `["secrets"]` | no |
| enable_cloudwatch_agent | Attach CloudWatch Agent policy to nodes. | `bool` | `true` | no |
| enable_xray | Attach X-Ray Daemon policy to nodes. | `bool` | `false` | no |
| enable_ssm_access | Attach SSM Managed Instance Core policy to nodes. | `bool` | `true` | no |
| alarm_actions | List of ARNs for CloudWatch alarm notifications (SNS topics). | `list(string)` | `[]` | no |
| tags | A map of tags to add to all resources. | `map(string)` | `{}` | no |

### Node Group Configuration

Each node group in the `node_groups` map supports the following attributes:

| Attribute | Description | Type | Default |
|-----------|-------------|------|---------|
| instance_types | List of EC2 instance types. | `list(string)` | Required |
| min_size | Minimum number of nodes. | `number` | Required |
| max_size | Maximum number of nodes. | `number` | Required |
| desired_size | Desired number of nodes. | `number` | Required |
| capacity_type | ON_DEMAND or SPOT. | `string` | `"ON_DEMAND"` |
| ami_type | AMI type (AL2_x86_64, AL2_ARM_64, BOTTLEROCKET_*). | `string` | `"AL2_x86_64"` |
| disk_size | Root volume size in GB. | `number` | `20` |
| disk_type | Root volume type (gp3, gp2, io1, etc.). | `string` | `"gp3"` |
| subnet_ids | Override module-level subnets for this node group. | `list(string)` | `null` |
| labels | Kubernetes labels for the node group. | `map(string)` | `{}` |
| taints | Kubernetes taints for the node group. | `list(object({...}))` | `[]` |

## Outputs

| Name | Description |
|------|-------------|
| cluster_id | The ID of the EKS cluster. |
| cluster_name | The name of the EKS cluster. |
| cluster_endpoint | The endpoint for the EKS cluster API server. |
| cluster_certificate_authority_data | Base64 encoded certificate data for cluster authentication. |
| cluster_version | The Kubernetes version running on the cluster. |
| cluster_security_group_id | Security group ID attached to the EKS cluster control plane. |
| node_security_group_id | Security group ID attached to the EKS node groups. |
| oidc_provider_arn | ARN of the OIDC Provider for IRSA. |
| oidc_provider_url | URL of the OIDC Provider. |
| node_iam_role_arn | ARN of the IAM role used by node groups. |
| node_iam_role_name | Name of the IAM role used by node groups. |
| kms_key_arn | ARN of the KMS key used for encryption. |
| cloudwatch_log_group_name | Name of the CloudWatch Log Group for cluster logs. |
| node_group_names | List of EKS managed node group names. |
| node_group_arns | List of ARNs for the EKS managed node groups. |

## Security Considerations

### Least Privilege
- Cluster and node IAM roles follow AWS managed policies with minimal required permissions
- Optional policies (CloudWatch, X-Ray, SSM) are disabled by default unless explicitly enabled

### Network Security
- Dedicated security groups for cluster control plane and node groups
- Node security groups only allow traffic from the cluster security group
- No `0.0.0.0/0` ingress rules on private resources
- Public API endpoint access can be restricted via `public_access_cidrs`

### Encryption
- EBS volumes on nodes are encrypted by default
- Kubernetes secrets are encrypted using KMS (key auto-created or user-provided)
- IMDSv2 enforced on all node groups to prevent metadata service attacks

### Secrets Management
- No hardcoded credentials or secrets in Terraform state
- Use AWS Secrets Manager for application secrets
- Mark sensitive outputs appropriately in consuming modules

## Monitoring

The module creates the following CloudWatch alarms by default:

1. **Node High CPU**: Triggers when average CPU utilization exceeds 80%
2. **Node Status Check Failed**: Triggers on instance or system status check failures
3. **Node High Memory**: Triggers when memory utilization exceeds 85% (requires CloudWatch Agent)
4. **Cluster API Server Errors**: Triggers on high 5xx error rates from the control plane

Configure `alarm_actions` with SNS topic ARNs to receive notifications.

## Best Practices

1. **Use private subnets** for node groups to isolate workloads from public internet
2. **Enable both public and private endpoints** for flexibility during VPC peering or Direct Connect scenarios
3. **Restrict public_access_cidrs** to known IP ranges in production environments
4. **Use SPOT instances** for fault-tolerant, cost-sensitive workloads
5. **Enable CloudWatch Agent** for enhanced container insights and memory metrics
6. **Enable SSM access** for secure, auditable node access without SSH key management
7. **Tag all resources** consistently for cost allocation and operational visibility

## Contributing

When contributing to this module:
- Follow Terraform formatting standards (`terraform fmt`)
- Validate changes with `terraform validate`
- Test in non-production environments before production deployment
- Update documentation for any new variables or outputs
- Ensure all changes comply with security best practices outlined in this README
