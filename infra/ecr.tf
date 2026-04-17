# ==============================================================================
# ECR Repository
# ==============================================================================

module "ecr" {
  source  = "terraform-aws-modules/ecr/aws"
  version = "3.2.0"

  repository_name = "${var.cluster_name}/api"

  repository_image_tag_mutability = "MUTABLE"
  repository_image_scanning_configuration = {
    scan_on_push = true
  }
  repository_encryption_configuration = {
    encryption_type = "KMS"
    kms_key         = aws_kms_key.main.arn
  }

  repository_lifecycle_policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Keep last 10 images"
        selection = {
          tagStatus     = "any"
          countType     = "imageCountMoreThan"
          countNumber   = 10
        }
        action = {
          type = "expire"
        }
      }
    ]
  })

  tags = merge(var.additional_tags, {
    Name = "${var.cluster_name}/api"
  })
}
