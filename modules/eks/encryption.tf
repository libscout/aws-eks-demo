# ==============================================================================
# KMS Encryption
# ==============================================================================

resource "aws_kms_key" "cluster" {
  count = var.kms_key_arn != null ? 0 : 1

  description             = "EKS cluster encryption key for ${var.cluster_name}"
  deletion_window_in_days = 7
  enable_key_rotation     = true

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "Enable IAM User Permissions"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        }
        Action   = "kms:*"
        Resource = "*"
      },
      {
        Sid    = "Allow EKS Service"
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
        Action = [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*",
          "kms:DescribeKey"
        ]
        Resource = "*"
      }
    ]
  })

  tags = var.tags
}

resource "aws_kms_alias" "cluster" {
  count         = var.kms_key_arn != null ? 0 : 1
  name          = "alias/eks-${var.cluster_name}"
  target_key_id = aws_kms_key.cluster[0].key_id
}
