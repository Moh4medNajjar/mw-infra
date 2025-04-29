output "ecr_repo_url" {
  value = aws_ecr_repository.my_ecr[*].repository_url
}