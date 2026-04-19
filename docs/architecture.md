# AWS EKS Demo Architecture

## Infrastructure Overview

```mermaid
graph TB
    subgraph AWS["AWS Region (us-east-2)"]
        subgraph VPC["VPC (10.0.0.0/16)"]
            IGW[Internet Gateway]
            NGW[NAT Gateway]
            
            subgraph Public["Public Subnets"]
                IGW
            end
            
            subgraph Private["Private Subnets"]
                EKS[EKS Cluster & Node Groups]
                RDS[RDS PostgreSQL]
                Redis[ElastiCache Redis]
                MSK[MSK Kafka Cluster]
            end
            
            IGW --> NGW
            NGW --> Private
        end
        
        ECR[ECR Repository]
        KMS[KMS Key]
        CW[CloudWatch Logs & Alarms]
        
        EKS -->|Pull Images| ECR
        KMS -.->|Encrypts| RDS
        KMS -.->|Encrypts| Redis
        KMS -.->|Encrypts| EKS
        KMS -.->|Encrypts| MSK
        
        EKS -->|Logs| CW
        RDS -->|Logs & Metrics| CW
        Redis -->|Metrics| CW
        MSK -->|Logs| CW
        VPC -->|Flow Logs| CW
    end
```

## Networking & Security Flow

```mermaid
graph LR
    subgraph EKS_Nodes["EKS Node Groups (Private Subnets)"]
        Nodes[EC2 Instances]
    end

    subgraph RDS_SG["RDS Security Group"]
        RDS[PostgreSQL :5432]
    end

    subgraph Redis_SG["ElastiCache Security Group"]
        Redis[Redis :6379]
    end

    subgraph MSK_SG["MSK Security Group"]
        Kafka[Kafka :9092]
    end

    Nodes -->|TCP 5432| RDS
    Nodes -->|TCP 6379| Redis
    Nodes -->|TCP 9092| Kafka
```

## Component Details

| Component | Module Source | Description |
|-----------|---------------|-------------|
| **VPC** | `modules/vpc` | Custom VPC with public/private subnets, NAT GW, IGW, Flow Logs |
| **EKS** | `modules/eks` | Managed cluster with node groups, IMDSv2, encryption, CloudWatch alarms |
| **RDS** | `modules/rds` | PostgreSQL with encryption, backups, Multi-AZ (prod only) |
| **ElastiCache** | `modules/elasticache` | Redis with encryption, snapshots, Multi-AZ (prod only) |
| **MSK** | `modules/msk` | Kafka cluster (KRaft mode) with TLS encryption, CloudWatch logging |
| **ECR** | `terraform-aws-modules/ecr` | Container registry with lifecycle policy |
| **KMS** | `aws_kms_key.main` | Cross-cutting encryption key for all data stores |
| **Security Groups** | `terraform-aws-modules/security-group` | Per-service SGs allowing EKS node access only |

## Environment Differences

| Setting | Dev | Prod |
|---------|-----|------|
| RDS Multi-AZ | No | Yes |
| RDS Deletion Protection | No | Yes |
| RDS Skip Final Snapshot | Yes | No |
| Redis Multi-AZ | No | Yes |
| Redis Auto-Failover | No | Yes |
| EKS Public Access | Yes | No |
| Kafka Brokers | 2 | 3 |
| Log Retention | 7 days | 90 days |
| KMS Deletion Window | 7 days | 30 days |
