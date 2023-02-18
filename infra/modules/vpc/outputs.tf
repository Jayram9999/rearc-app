output "vpc_id" {
  value = module.vpc.vpc_id
}

output "private_subnets" {
  value = module.vpc.private_subnets[0]
}

output "public_subnets" {
  value = module.vpc.public_subnets[1]
}