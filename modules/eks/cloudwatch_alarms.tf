# ==============================================================================
# CloudWatch Alarms for EKS Node Pressure & Cluster Health
# ==============================================================================

# Alarm: High CPU Utilization on EKS Node Groups
resource "aws_cloudwatch_metric_alarm" "node_high_cpu" {
  for_each = var.node_groups

  alarm_name          = "${var.cluster_name}-${each.key}-high-cpu"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "Triggers when average CPU utilization for the EKS node group '${each.key}' exceeds 80% for 2 consecutive periods."
  alarm_actions       = var.alarm_actions
  treat_missing_data  = "notBreaching"

  dimensions = {
    AutoScalingGroupName = aws_eks_node_group.this[each.key].node_group_name
  }

  tags = var.tags
}

# Alarm: EC2 Status Check Failed (Indicates Node Failure/Pressure)
resource "aws_cloudwatch_metric_alarm" "node_status_check_failed" {
  for_each = var.node_groups

  alarm_name          = "${var.cluster_name}-${each.key}-status-check-failed"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "StatusCheckFailed"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Maximum"
  threshold           = 0
  alarm_description   = "Triggers when any instance in the EKS node group '${each.key}' fails system or instance status checks."
  alarm_actions       = var.alarm_actions
  treat_missing_data  = "notBreaching"

  dimensions = {
    AutoScalingGroupName = aws_eks_node_group.this[each.key].node_group_name
  }

  tags = var.tags
}

# Alarm: High Memory Utilization (Requires CloudWatch Agent / Container Insights)
resource "aws_cloudwatch_metric_alarm" "node_high_memory" {
  for_each = var.enable_cloudwatch_agent ? var.node_groups : {}

  alarm_name          = "${var.cluster_name}-${each.key}-high-memory"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "MemoryUtilization"
  namespace           = "CWAgent"
  period              = 300
  statistic           = "Average"
  threshold           = 85
  alarm_description   = "Triggers when average memory utilization for the EKS node group '${each.key}' exceeds 85%. Requires CloudWatch Agent deployment."
  alarm_actions       = var.alarm_actions
  treat_missing_data  = "notBreaching"

  dimensions = {
    AutoScalingGroupName = aws_eks_node_group.this[each.key].node_group_name
    InstanceId           = "*"
  }

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "node_cloudwatch" {
  count      = var.enable_cloudwatch_agent ? 1 : 0
  policy_arn = "arn:${data.aws_partition.current.partition}:iam::aws:policy/CloudWatchAgentServerPolicy"
  role       = aws_iam_role.node.name
}


# Alarm: EKS Control Plane API Server Error Rate
resource "aws_cloudwatch_metric_alarm" "cluster_api_errors" {
  alarm_name          = "${var.cluster_name}-api-server-errors"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "apiserver_request_total"
  namespace           = "AWS/EKS"
  period              = 300
  statistic           = "Sum"
  threshold           = 10
  alarm_description   = "Triggers when the EKS control plane API server experiences a high rate of 5xx errors."
  alarm_actions       = var.alarm_actions
  treat_missing_data  = "notBreaching"

  dimensions = {
    ClusterName = var.cluster_name
  }

  tags = var.tags
}
