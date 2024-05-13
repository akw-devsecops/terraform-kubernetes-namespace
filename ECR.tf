resource "aws_ecr_repository" "application_repos" {
  for_each = toset(var.ecr_repos)

  name = each.value

  image_scanning_configuration {
    scan_on_push = false
  }
}

resource "aws_ecr_repository_policy" "application_repos" {
  for_each = { for repo, values in aws_ecr_repository.application_repos : repo => values if var.ecr_repo_role != "" }

  repository = each.value.name
  policy     = data.aws_iam_policy_document.application_repos[0].json
}

data "aws_iam_policy_document" "application_repos" {
  count = var.ecr_repo_role != "" ? 1 : 0

  version = "2012-10-17"

  statement {
    sid    = "AllowCrossAccountPush"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = concat([var.ecr_repo_role], var.additional_ecr_repo_roles)
    }
    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:CompleteLayerUpload",
      "ecr:InitiateLayerUpload",
      "ecr:PutImage",
      "ecr:UploadLayerPart",
    ]
  }

  statement {
    sid    = "LambdaECRImageRetrievalPolicy"
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
    actions = [
      "ecr:BatchGetImage",
      "ecr:GetDownloadUrlForLayer",
    ]
  }
}

resource "aws_ecr_lifecycle_policy" "this" {
  for_each = { for repo, values in aws_ecr_repository.application_repos : repo => values if var.create_ecr_lifecycle }

  repository = each.value.name
  policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Expire images older than 7 days"
        selection = {
          tagStatus   = "untagged"
          countType   = "sinceImagePushed"
          countUnit   = "days"
          countNumber = 7
        },
        action = {
          type = "expire"
        }
      },
      {
        rulePriority = 2
        description  = "Keep last 50 images"
        selection = {
          tagStatus     = "any"
          countType     = "imageCountMoreThan"
          countNumber   = 50
        }
        action = {
          type = "expire"
        }
      }
    ]
  })
}
