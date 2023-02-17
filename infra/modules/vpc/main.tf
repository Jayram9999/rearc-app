module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "rearc-app"
  cidr = "10.0.0.0/16"

  azs             = ["us-east-1a", "us-east-1b", "us-east-1c", "us-east-1d"]
  public_subnets = var.public_subnet_cidrs
  private_subnets  = var.private_subnet_cidrs
  enable_nat_gateway = true
  tags = {
    Terraform = "true"
    Environment = "rearc"
  }
}
