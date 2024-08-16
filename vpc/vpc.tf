module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = ">= 3.0"

  name = "eks-vpc"
  cidr = var.vpc_cidr

  azs             = var.azs
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets

  enable_nat_gateway = true
  single_nat_gateway = true

  enable_dns_support   = true
  enable_dns_hostnames = true

  instance_tenancy = var.instance_tenancy

  tags = {
    ManagedBy = "api"
  }
}