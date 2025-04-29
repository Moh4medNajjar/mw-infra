module "mw_rds" {
  source            = "../modules/rds"
  allocated_storage = var.rds_allocated_storage
  instance_class    = var.rds_instance_class
  username          = var.rds_username
  vpc_id            = module.mw_vpc.vpc_id
  tags              = var.tags
  subnets_id_rds    = [module.mw_private_subnets.subnet_ids[2], module.mw_private_subnets.subnet_ids[3]]
  password          = var.password
}

module "mw_s3" {
  source        = "../modules/s3"
  s3_names      = var.s3_names
  s3_versioning = var.s3_versioning
  tags          = var.tags
}
