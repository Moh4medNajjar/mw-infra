locals {
  name_suffix = "${lookup(var.tags, "Environment")}-${lookup(var.tags, "Project")}"
}

resource "aws_ecs_cluster" "my_ecs_cluster" {
  name = "ecs-cluster-${local.name_suffix}"

  tags = {
    Name        = "ecs-cluster-${local.name_suffix}"
    Owner       = lookup(var.tags, "Owner")
    Application = "computing"
    Project     = lookup(var.tags, "Project")
    Environment = lookup(var.tags, "Environment")
  }
}

resource "aws_ecs_cluster_capacity_providers" "my_ecs_cluster_attach_with_capacity_provider" {
  cluster_name = aws_ecs_cluster.my_ecs_cluster.name

  capacity_providers = [
    var.capacity_provider_name
  ]

  default_capacity_provider_strategy {
    capacity_provider = var.capacity_provider_name
    weight            = 1
    base              = 1
  }

  depends_on = [
    aws_ecs_cluster.my_ecs_cluster,
    var.capacity_provider_name
  ]
}
