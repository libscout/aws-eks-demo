# ==============================================================================
# MSK Kafka
# ==============================================================================

module "msk" {
  source  = "terraform-aws-modules/msk-kafka-cluster/aws"
  version = "3.1.0"

  cluster_name           = "${var.cluster_name}-kafka"
  kafka_version          = "3.5.1"
  number_of_broker_nodes = var.msk_number_of_broker_nodes

  broker_node_client_subnets  = module.vpc.private_subnets
  broker_node_instance_type   = var.msk_broker_instance_type
  broker_node_security_groups = [module.msk_sg.security_group_id]
  broker_node_ebs_volume_size = 100

  encryption_in_transit_client_broker = "TLS"

  logging_enabled = true
  cloudwatch_log_group_name          = "/aws/msk/${var.cluster_name}"
  cloudwatch_log_group_retention_in_days = var.environment == "prod" ? 90 : 30

  tags = merge(var.additional_tags, {
    Name = "${var.cluster_name}-kafka"
  })
}

module "msk_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.3.1"

  name        = "${var.cluster_name}-msk-sg"
  description = "Security group for MSK Kafka cluster"
  vpc_id      = module.vpc.vpc_id

  ingress_cidr_blocks = []
  ingress_rules       = ["kafka-tcp"]
  ingress_with_source_security_group_id = [
    {
      rule                     = "kafka-tcp"
      source_security_group_id = module.eks.node_security_group_id
    }
  ]

  egress_rules = ["all-all"]

  tags = merge(var.additional_tags, {
    Name = "${var.cluster_name}-msk-sg"
  })
}