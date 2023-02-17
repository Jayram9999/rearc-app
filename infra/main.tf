module "vpc" {
  source = "./vpc/"
  public_subnet_cidrs = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
}

module "eks" {
  source = "./eks/"
  cluster_name = var.cluster_name
}