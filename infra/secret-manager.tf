# ==============================================================================
# KMS Key (Cross-cutting encryption)
# ==============================================================================

resource "aws_kms_key" "main" {
  description             = "KMS key for encrypting EKS demo resources"
  deletion_window_in_days = 7
  enable_key_rotation     = true

  tags = merge(var.additional_tags, {
    Name = "${var.cluster_name}-kms-key"
  })
}