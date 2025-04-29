module "mw_vpc" {
  source     = "../modules/vpc"
  cidr_block = var.mw_cidr_block
  tags       = var.tags
}

module "mw_public_subnets" {
  source       = "../modules/public_subnet"
  azs          = var.public_azs
  public_cidrs = var.public_cidrs
  tags         = var.tags
  vpc_id       = module.mw_vpc.vpc_id
  public_rt    = module.mw_vpc.public_rt_id
}

module "mw_private_subnets" {
  source        = "../modules/private_subnet"
  azs           = var.private_azs
  tags          = var.tags
  vpc_id        = module.mw_vpc.vpc_id
  private_cidrs = var.private_cidrs
  private_rt    = module.mw_nat_gateway.private_rt
}

module "mw_nat_gateway" {
  source           = "../modules/nat_gateway"
  public_subnet_id = module.mw_public_subnets.subnet_ids[0]
  tags             = var.tags
  vpc_id           = module.mw_vpc.vpc_id
}



module "mw_bastion_host" {
  source = "../modules/bastion"
  bastion_instance_type = var.bastion_instance_type
  bucketname            = module.mw_s3.buckets_name[0]
  subnet_id_public      = module.mw_public_subnets.subnet_ids[0]
  tags                  = var.tags
  vpc_id                = module.mw_vpc.vpc_id
}



