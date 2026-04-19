# ==============================================================================
# MSK Kafka
# ==============================================================================

module "msk" {
  source = "../modules/msk"

  cluster_name           = "${var.cluster_name}-kafka"
  kafka_version          = var.msk_kafka_version
  number_of_broker_nodes = var.msk_number_of_broker_nodes

  broker_node_client_subnets  = module.vpc.private_subnets
  broker_node_instance_type   = var.msk_broker_instance_type
  broker_node_security_groups = [module.msk_sg.security_group_id]
  broker_node_ebs_volume_size = var.msk_broker_ebs_volume_size

  encryption_in_transit_client_broker = "TLS"

  logging_enabled                        = true
  cloudwatch_log_group_name              = "/aws/msk/${var.cluster_name}"
  cloudwatch_log_group_retention_in_days = var.log_retention_in_days

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
  ingress_rules       = ["kafka-broker-tcp"]
  ingress_with_source_security_group_id = [
    {
      rule                     = "kafka-broker-tcp"
      source_security_group_id = module.eks.node_sg_id
    }
  ]

  egress_cidr_blocks = [module.vpc.vpc_cidr_block]
  egress_rules       = ["all-all"]

  tags = merge(var.additional_tags, {
    Name = "${var.cluster_name}-msk-sg"
  })
}
