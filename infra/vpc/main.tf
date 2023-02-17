module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "rearc-app"
  cidr = "10.0.0.0/16"

  azs             = ["us-east-1a", "us-east-1b", "us-east-1c"]
  public_subnets = var.public_subnet_cidrs
  private_subnets  = var.private_subnet_cidrs

  tags = {
    Terraform = "true"
    Environment = "rearc"
  }
}
