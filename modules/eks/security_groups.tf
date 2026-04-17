# ==============================================================================
# EKS Cluster Security Group
# ==============================================================================

resource "aws_security_group" "cluster" {
  name_prefix = "${var.cluster_name}-cluster-"
  description = "Security group for the EKS cluster control plane"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow worker nodes to communicate with the cluster API server"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.subnet_cidrs
  }

  egress {
    description = "Allow all outbound traffic from the cluster control plane"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name = "${var.cluster_name}-cluster"
  })
}

# ==============================================================================
# EKS Node Group Security Group
# ==============================================================================

resource "aws_security_group" "node" {
  name_prefix = "${var.cluster_name}-node-"
  description = "Security group for EKS managed node groups"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow inbound traffic from the EKS control plane and other nodes"
    from_port   = 1025
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = var.subnet_cidrs
  }

  ingress {
    description = "Allow node-to-node communication within the cluster"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = true
  }

  egress {
    description = "Allow all outbound traffic from worker nodes"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name = "${var.cluster_name}-node"
  })
}
