resource "aws_ecr_repository" "this" {
  name                 = var.ecr_name
  image_tag_mutability = "MUTABLE"
  encryption_configuration {
    encryption_type = "AES256"
  }
  image_scanning_configuration {
    scan_on_push = var.scan_on_push
  }
  tags = {
    Name = var.ecr_name
  }
}

data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "repo" {
  statement {
    sid     = "AllowAccountPushPull"
    effect  = "Allow"
    actions = [
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "ecr:BatchCheckLayerAvailability",
      "ecr:DescribeImages",
      "ecr:PutImage",
      "ecr:InitiateLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:CompleteLayerUpload"
    ]
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }
    resources = [aws_ecr_repository.this.arn]
  }
}

resource "aws_ecr_repository_policy" "this" {
  repository = aws_ecr_repository.this.name
  policy     = data.aws_iam_policy_document.repo.json
}

resource "aws_ecr_lifecycle_policy" "this" {
  repository = aws_ecr_repository.this.name
  policy     = jsonencode({
    rules = [{
      rulePriority = 1
      description  = "Expire untagged images older than 14 days"
      selection    = {
        tagStatus   = "untagged"
        countType   = "sinceImagePushed"
        countUnit   = "days"
        countNumber = 14
      }
      action = { type = "expire" }
    }]
  })
}