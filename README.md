# AWS EKS Demo Infrastructure

Terraform-managed AWS infrastructure featuring an EKS cluster with managed node groups, RDS PostgreSQL, ElastiCache
Redis, and MSK Kafka.

## How to Run

### Prerequisites

- **AWS CLI:** Configured with credentials/role access to `us-east-2`.
- **Terraform:** Version `1.5+`.
- **Permissions:** Assume role ARNs for Dev/Prod environments.

### Initialize

```bash
terraform init
```

### Deploy (Dev)

```bash
terraform plan -var-file="env/dev.tfvars"
terraform apply -var-file="env/dev.tfvars"
```

### Deploy (Prod)

```bash
terraform plan -var-file="env/prod.tfvars"
terraform apply -var-file="env/prod.tfvars"
```

## Architecture

See detailed diagrams and component breakdown in [docs/architecture.md](docs/architecture.md).

## Assumptions / Key Decisions

- **Shared Infrastructure Scope:** This repository provisions shared infrastructure only (VPC, EKS, data stores). Application-specific resources and deployments are managed separately.
- **Service Deployment & IAM:** Each service maintains its own repo and infrastructure (Terraform + Helm), creates the `ServiceAccount` and mapping it to an IAM role via IRSA or EKS Pod Identity.

## What is Skipped and Why

- **Load Balancer:** I think it should be installed using Helm. But to use Helm provider we need to split infra into several root modules:

1. Networking
2. EKS

   2.1. EKS bootstrap

   2.2. EKS setup with Helm

4. Storage services declaration
