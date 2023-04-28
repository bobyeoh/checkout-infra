resource "aws_ecr_repository" "app_ecr_repo" {
  name = "${var.app_name}-backend-${var.environment}"
}
resource "aws_ecr_repository_policy" "app_ecr_repo" {
  repository = "${var.app_name}-backend-${var.environment}"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "Allow ECS Task Roles",
        Effect = "Allow",
        Principal = {
          AWS = var.ecs_execution_role_arn
        },
        Action = [
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "ecr:BatchCheckLayerAvailability"
        ]
      }
    ]
  })
}