# ==============================================================================
# ElastiCache Redis
# ==============================================================================

module "elasticache" {
  source = "../modules/elasticache"

  cluster_id        = "${var.cluster_name}-redis"
  description       = "Redis cluster for ${var.cluster_name}"
  engine            = "redis"
  engine_version    = var.redis_engine_version
  node_type         = var.redis_node_type
  num_cache_nodes   = var.redis_num_cache_nodes
  port              = var.redis_port
  apply_immediately = true

  subnet_ids         = module.vpc.private_subnets
  security_group_ids = [module.redis_sg.security_group_id]

  transit_encryption_enabled = true
  at_rest_encryption_enabled = true
  kms_key_id                 = aws_kms_key.main.arn

  automatic_failover_enabled = var.environment == "prod"
  multi_az_enabled           = var.environment == "prod"
  snapshot_retention_limit   = var.redis_snapshot_retention_limit
  snapshot_window            = var.redis_snapshot_window

  tags = merge(var.additional_tags, {
    Name = "${var.cluster_name}-redis"
  })
}

module "redis_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.3.1"

  name        = "${var.cluster_name}-redis-sg"
  description = "Security group for ElastiCache Redis cluster"
  vpc_id      = module.vpc.vpc_id

  ingress_cidr_blocks = []
  ingress_rules       = ["redis-tcp"]
  ingress_with_source_security_group_id = [
    {
      rule                     = "redis-tcp"
      source_security_group_id = module.eks.node_sg_id
    }
  ]

  egress_cidr_blocks = [module.vpc.vpc_cidr_block]
  egress_rules       = ["all-all"]

  tags = merge(var.additional_tags, {
    Name = "${var.cluster_name}-redis-sg"
  })
}
