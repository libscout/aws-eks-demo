# ==============================================================================
# ECR Repository
# ==============================================================================

module "ecr" {
  source  = "terraform-aws-modules/ecr/aws"
  version = "3.2.0"

  repository_name                 = "${var.cluster_name}/api"
  repository_image_tag_mutability = var.ecr_tag_mutability

  repository_lifecycle_policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Keep last ${var.ecr_lifecycle_image_count} images"
        selection = {
          tagStatus   = "any"
          countType   = "imageCountMoreThan"
          countNumber = var.ecr_lifecycle_image_count
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
