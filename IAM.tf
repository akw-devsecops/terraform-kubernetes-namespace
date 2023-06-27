#############################################
#                READ ROLE
#############################################
resource "aws_iam_role" "eks_ns_view" {
  count = var.create_iam_roles ? 1 : 0

  name                 = "eks_ns-${kubernetes_namespace.default.metadata[0].name}-view" #don't like that eks_ns has _ and the rest has -
  permissions_boundary = var.policy_boundary_arn

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = "sts:AssumeRole",
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        }
      }
    ]
  })
}

resource "aws_iam_policy" "eks_ns_view" {
  count = var.create_iam_roles ? 1 : 0

  name = "eks_ns-${kubernetes_namespace.default.metadata[0].name}-view"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Action = [
        "ecr:DescribeImageScanFindings",
        "ecr:GetLifecyclePolicyPreview",
        "ecr:GetDownloadUrlForLayer",
        "ecr:ListTagsForResource",
        "ecr:ListImages",
        "ecr:BatchGetImage",
        "ecr:DescribeImages",
        "ecr:DescribeRepositories",
        "ecr:BatchCheckLayerAvailability",
        "ecr:GetRepositoryPolicy",
        "ecr:GetLifecyclePolicy",
        "ecr:Read*"
      ],
      Resource = "*",
      Condition = {
        StringEquals = {
          "aws:ResourceTag/appid" = "$${aws:PrincipalTag/appid}"
        }
      }
      },
      {
        Effect = "Deny",
        Action = [
          "ecr:TagResource",
          "ecr:UntagResource"
        ],
        Resource = "*"
      },
      {
        Effect = "Allow",
        Action = [
          "eks:DescribeCluster"
        ],
        Resource = "arn:aws:eks:${var.region}:${data.aws_caller_identity.current.id}:cluster/${var.cluster_name}"
      },
      {
        Effect = "Allow",
        Action = [
          "ecr:GetAuthorizationToken",
          "ecr:DescribeRepositories"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eks_ns_view" {
  count = var.create_iam_roles ? 1 : 0

  role       = aws_iam_role.eks_ns_view[0].name
  policy_arn = aws_iam_policy.eks_ns_view[0].arn
}

#############################################
#               READ/WRITE ROLE
#############################################
resource "aws_iam_role" "eks_ns_edit" {
  count = var.create_iam_roles ? 1 : 0

  name                 = "eks_ns-${kubernetes_namespace.default.metadata[0].name}-edit"
  permissions_boundary = var.policy_boundary_arn

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = "sts:AssumeRole",
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        }
      }
    ]
  })
}

resource "aws_iam_policy" "eks_ns_edit" {
  count = var.create_iam_roles ? 1 : 0

  name = "eks_ns-${kubernetes_namespace.default.metadata[0].name}-edit"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Deny",
        Action = [
          "ecr:TagResource",
          "ecr:UntagResource"
        ],
        Resource = "*"
      },
      {
        Effect = "Allow",
        Action = [
          "eks:DescribeCluster"
        ],
        Resource = "arn:aws:eks:${var.region}:${data.aws_caller_identity.current.id}:cluster/${var.cluster_name}"
      },
      {
        Effect   = "Allow",
        Action   = "ecr:*",
        Resource = "*",
        Condition = {
          StringEquals = {
            "aws:ResourceTag/appid" = "$${aws:PrincipalTag/appid}"
          }
        }
      },
      {
        Effect = "Allow",
        Action = [
          "ecr:GetAuthorizationToken",
          "ecr:DescribeRepositories"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eks_ns_edit" {
  count = var.create_iam_roles ? 1 : 0

  role       = aws_iam_role.eks_ns_edit[0].name
  policy_arn = aws_iam_policy.eks_ns_edit[0].arn
}
