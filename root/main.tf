//###################################################################################
//###################################################################################
//######################### .. Networking .. ########################################
//###################################################################################
//###################################################################################

module "mw-vpc" {
  source     = "../modules/vpc"
  cidr_block = var.mw_cidr_block
  tags       = var.tags
}

module "mw_public_subnets" {
  source       = "../modules/public_subnet"
  azs          = var.public_azs
  public_cidrs = var.public_cidrs
  tags         = var.tags
  vpc_id       = module.mw-vpc.vpc_id
  public_rt    = module.mw-vpc.public_rt_id
}

module "mw_private_subnets" {
  source        = "../modules/private_subnet"
  azs           = var.private_azs
  tags          = var.tags
  vpc_id        = module.mw-vpc.vpc_id
  private_cidrs = var.private_cidrs
  private_rt    = module.mw_nat_gateway.mw_private_rt
}

module "mw_nat_gateway" {
  source           = "../modules/nat_gateway"
  public_subnet_id = module.mw_public_subnets.subnet_ids[0]
  tags             = var.tags
  vpc_id           = module.mw-vpc.vpc_id
}

//###################################################################################
//###################################################################################
//######################### .. ECS .. ###############################################
//###################################################################################
//###################################################################################

module "mw_alb" {
  source     = "../modules/alb"
  subnet_ids = [module.mw_public_subnets.subnet_ids[0], module.mw_public_subnets.subnet_ids[1]]
  tags       = var.tags
  vpc_id     = module.mw-vpc.vpc_id
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
  vpc_id            = module.mw-vpc.vpc_id
}

module "mw_ecs" {
  source = "../modules/ecs"

  capacity_provider_name = module.mw_cp.capacity_provider_name
  tags                   = var.tags
}

module "mw_ecs_task" {
  source = "../modules/ecs_task"

  alb_listener_arn       = module.mw_alb.alb_listener_arn
  capacity_provider_name = module.mw_cp.capacity_provider_name
  cluster_name           = module.mw_ecs.ecs_cluster_name
  container_definitions  = file("./container_definitions/mw_container_def.json")
  container_name         = var.container_name
  container_port         = var.container_port
  cpu                    = var.cpu
  desired_count          = var.desired_count
  family                 = var.family
  memory                 = var.memory
  service_name           = var.service_name
  subnet_ids             = [module.mw_private_subnets.subnet_ids[0], module.mw_private_subnets.subnet_ids[1]]
  tags                   = var.tags
  target_group_arn       = module.mw_alb.alb_target_group_arn

  vpc_id = module.mw-vpc.vpc_id
}





















