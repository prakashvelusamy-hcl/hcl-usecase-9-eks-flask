
module "vpc" {
  source   = "./modules/terraform-aws-vpc"
  vpc_cidr = var.vpc_cidr
  pub_sub_count  = var.pub_sub_count
  priv_sub_count = var.priv_sub_count
  nat_count      = var.nat_count
}
# module "alb" {
#   source = "./modules/terraform-aws-alb"
#   public_subnet_ids = module.vpc.public_subnet_ids
#   environment = var.environment
#   vpc_id = module.vpc.vpc_id
# }

module "eks" {
  source = "./modules/terraform-aws-eks"
  private_subnet_ids = module.vpc.private_subnet_ids
  public_subnet_ids = module.vpc.public_subnet_ids
}