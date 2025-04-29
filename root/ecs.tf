

locals {
  name_suffix = "${lookup(var.tags, "Environment")}-${lookup(var.tags, "Project")}"
}
############log group
resource "aws_cloudwatch_log_group" "my_log_group" {
  name = "/ecs/ecs-task-integ-mw-monitoring"
  retention_in_days = 30
  tags = {
    Name        = "lg-${local.name_suffix}"
    Owner       = lookup(var.tags, "Owner")
    Application = "monitoring" #lookup(var.tags, "Application")
    Project     = lookup(var.tags, "Project")
    Environment = lookup(var.tags, "Environment")
  }
}


module "mw_cp" {
  source = "../modules/capacity_provider"

  desired_capacity  = var.desired_capacity
  instance_type     = var.instance_type
  max_size          = var.max_size
  min_size          = var.min_size
  subnet_ids        = [module.mw_private_subnets.subnet_ids[0], module.mw_private_subnets.subnet_ids[1]]
  tags              = var.tags
  target_group_arns = [module.mw_alb.alb_target_group_arn]
  vpc_id            = module.mw_vpc.vpc_id
}

module "mw_ecs" {
  source = "../modules/ecs"

  capacity_provider_name = module.mw_cp.capacity_provider_name
  tags                   = var.tags
}

module "mw_ecs_task" {
  source = "../modules/ecs_task"
  ecs_tasks_list        = var.ecs_tasks_list
  alb_listener_arn       = module.mw_alb.alb_listener_arn
  capacity_provider_name = module.mw_cp.capacity_provider_name
  cluster_name           = module.mw_ecs.ecs_cluster_name
  container_definitions  = [for task in var.ecs_tasks_list : task.container_definitions]
  container_name        = [for task in var.ecs_tasks_list : task.container_name]
  container_port        = [for task in var.ecs_tasks_list : task.container_port]
  cpu                   = var.cpu
  desired_count         = var.desired_count
  family                = [for task in var.ecs_tasks_list : task.family]
  memory                = var.memory
  service_name          = [for task in var.ecs_tasks_list : task.service_name]
  network_mode          = var.network_mode
  launch_type           = var.launch_type
  subnet_ids            = [module.mw_private_subnets.subnet_ids[0], module.mw_private_subnets.subnet_ids[1]]
  target_group_arn      = module.mw_alb.alb_target_group_arn
  vpc_id                = module.mw_vpc.vpc_id
  isFront               = [for task in var.ecs_tasks_list : task.isFront]
  depends_on            = [module.mw_alb]
  tags                  = var.tags

}