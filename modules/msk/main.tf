# ==============================================================================
# MSK Module
# ==============================================================================

resource "aws_cloudwatch_log_group" "msk" {
  count = var.logging_enabled ? 1 : 0

  name              = var.cloudwatch_log_group_name != null ? var.cloudwatch_log_group_name : "/aws/msk/${var.cluster_name}"
  retention_in_days = var.cloudwatch_log_group_retention_in_days

  tags = var.tags
}

resource "aws_msk_cluster" "this" {
  cluster_name           = var.cluster_name
  kafka_version          = var.kafka_version
  number_of_broker_nodes = var.number_of_broker_nodes

  broker_node_group_info {
    instance_type   = var.broker_node_instance_type
    ebs_volume_size = var.broker_node_ebs_volume_size
    client_subnets  = var.broker_node_client_subnets
    security_groups = var.broker_node_security_groups
  }

  encryption_info {
    encryption_in_transit {
      client_broker = var.encryption_in_transit_client_broker
    }
    encryption_at_rest_kms_key_arn = var.encryption_at_rest_kms_key_arn
  }

  logging_info {
    broker_logs {
      cloudwatch_logs {
        enabled   = var.logging_enabled
        log_group = var.logging_enabled ? aws_cloudwatch_log_group.msk[0].name : null
      }
    }
  }

  enhanced_monitoring = var.monitoring_level

  tags = var.tags
}
