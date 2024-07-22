module "vpc" {
  source          = "./modules/vpc"
  env             = var.env
  region          = var.region
  zone1           = var.zone1
  zone2           = var.zone2
  public_nacl_id  = module.security.public_nacl_id
  private_nacl_id = module.security.private_nacl_id
}

module "security" {
  source = "./modules/security"
  env    = var.env
  vpc_id = module.vpc.vpc_id
}