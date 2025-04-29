/*module "mw_alb" {
  source     = "../modules/alb"
  subnet_ids = [module.mw_public_subnets.subnet_ids[0], module.mw_public_subnets.subnet_ids[1]]
  tags       = var.tags
  vpc_id     = module.mw_vpc.vpc_id
}
*/