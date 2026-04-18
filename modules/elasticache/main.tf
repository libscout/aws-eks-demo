# ==============================================================================
# ElastiCache Module
# ==============================================================================

resource "aws_elasticache_subnet_group" "this" {
  name       = var.cluster_id
  subnet_ids = var.subnet_ids

  tags = merge(var.tags, {
    Name = var.cluster_id
  })
}

resource "aws_elasticache_replication_group" "this" {
  replication_group_id = var.cluster_id
  description          = var.description

  engine               = var.engine
  engine_version       = var.engine_version
  node_type            = var.node_type
  num_cache_clusters   = var.num_cache_nodes

  port                = var.port
  apply_immediately   = var.apply_immediately

  security_group_ids  = var.security_group_ids
  subnet_group_name   = aws_elasticache_subnet_group.this.name

  transit_encryption_enabled = var.transit_encryption_enabled
  at_rest_encryption_enabled = var.at_rest_encryption_enabled
  kms_key_id                 = var.kms_key_id

  automatic_failover_enabled = var.automatic_failover_enabled
  multi_az_enabled           = var.multi_az_enabled

  snapshot_retention_limit = var.snapshot_retention_limit
  snapshot_window          = var.snapshot_window
  maintenance_window       = var.maintenance_window

  tags = merge(var.tags, {
    Name = var.cluster_id
  })
}
