resource "aws_s3_bucket" "tf_state" {
  count = var.create_state_bucket ? 1 : 0

  bucket = try(var.state_bucket_name, "${kubernetes_namespace.default.metadata[0].name}-tf-state")
}

resource "aws_s3_bucket_acl" "tf_states" {
  count = var.create_state_bucket ? 1 : 0

  bucket = aws_s3_bucket.tf_state[0].id
  acl    = "private"

  depends_on = [aws_s3_bucket_ownership_controls.tf_states[0]]
}

resource "aws_s3_bucket_ownership_controls" "tf_states" {
  count = var.create_state_bucket ? 1 : 0

  bucket = aws_s3_bucket.tf_state[0].id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_versioning" "tf_states" {
  count = var.create_state_bucket ? 1 : 0

  bucket = aws_s3_bucket.tf_state[0].id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "tf_state" {
  count = var.create_state_bucket ? 1 : 0

  bucket = aws_s3_bucket.tf_state[0].id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

data "aws_iam_policy_document" "https_only" {
  count = var.create_state_bucket ? 1 : 0

  statement {
    sid    = "HTTPSOnly"
    effect = "Deny"

    principals {
      identifiers = ["*"]
      type        = "*"
    }

    actions = [
      "s3:*"
    ]

    resources = [
      aws_s3_bucket.tf_state[0].arn,
      "${aws_s3_bucket.tf_state[0].arn}/*",
    ]

    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["false"]
    }
  }
}

resource "aws_s3_bucket_policy" "https_only" {
  count = var.create_state_bucket ? 1 : 0

  bucket = aws_s3_bucket.tf_state[0].id
  policy = data.aws_iam_policy_document.https_only[0].json
}
