module "vpc" {
  source = "./modules/vpc/"
  public_subnet_cidrs = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
}

module "eks" {
  source = "./modules/eks/"
  cluster_name = var.cluster_name
  vpc_id = module.vpc.vpc_id
  priv_subnet_id = module.vpc.private_subnets
  publ_subnet_id = module.vpc.public_subnets
  depends_on = [module.vpc]
}