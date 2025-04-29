locals {
  application = "storage"
  name_suffix = "${lookup(var.tags, "Environment")}-${lookup(var.tags, "Project")}"
}


resource "aws_ecr_repository" "my_ecr" {
  count = length(var.repo_name)
  name = "${var.repo_name[count.index]}-ecr-${local.name_suffix}"
  image_tag_mutability = "MUTABLE" #var.mutability #"MUTABLE"
  image_scanning_configuration {
    scan_on_push = var.scan_on_push
  }
  force_delete = var.force_delete
  tags = {
    Name        = "ecr-${local.name_suffix}"
    Owner       = lookup(var.tags, "Owner")
    Application = local.application #lookup(var.tags, "Application")
    Project     = lookup(var.tags, "Project")
    Environment = lookup(var.tags, "Environment")
  }
}

resource "aws_ecr_lifecycle_policy" "my_ecr_lifecycle_policy" {
  count = length(var.repo_name)
  repository = aws_ecr_repository.my_ecr[count.index].name
  policy =  jsonencode({
    rules: [
      {
      rulePriority = 1
      description   = "Keep only 10 images"
      selection     = {
        countType        = "imageCountMoreThan"
        countNumber      = 10
        tagStatus        = "tagged"
        tagPrefixList   = ["integ"]
      }
      action = {
        type = "expire"
      }
    }
    ]
    }
  )
}