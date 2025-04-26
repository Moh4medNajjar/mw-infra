locals {
  name_suffix = "${lookup(var.tags, "Environment")}-${lookup(var.tags, "Project")}-${lookup(var.tags, "Application")}"
}

resource "aws_ecs_cluster" "mw_ecs_cluster" {
  name = "ecs-cluster-${local.name_suffix}"

  tags = {
    Name        = "ecs-cluster-${local.name_suffix}"
    Owner       = lookup(var.tags, "Owner")
    Application = lookup(var.tags, "Application")
    Project     = lookup(var.tags, "Project")
    Environment = lookup(var.tags, "Environment")
  }
}

resource "aws_ecs_cluster_capacity_providers" "mw_ecs_cluster_attach_with_capacity_provider" {
  cluster_name = aws_ecs_cluster.mw_ecs_cluster.name

  capacity_providers = [
    var.capacity_provider_name
  ]

  default_capacity_provider_strategy {
    capacity_provider = var.capacity_provider_name
    weight            = 1
    base              = 1
  }

  depends_on = [
    aws_ecs_cluster.mw_ecs_cluster,
    var.capacity_provider_name // assuming this exists; adjust if needed
  ]
}
