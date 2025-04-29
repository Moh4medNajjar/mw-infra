
locals {
  name_suffix = "${lookup(var.tags, "Environment")}-${lookup(var.tags, "Project")}"
}
# Create a CloudWatch Log Group
resource "aws_cloudwatch_log_group" "my_log_group" {
  name = var.log_group_name
  retention_in_days = var.log_retention
  tags = {
    Name        = "alb-sg-${local.name_suffix}"
    Owner       = lookup(var.tags, "Owner")
    Application = "monitoring" #lookup(var.tags, "Application")
    Project     = lookup(var.tags, "Project")
    Environment = lookup(var.tags, "Environment")
  }
}
# log group que poue le ECS

