module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "vpc-${local.name}"
  cidr = local.cidr

  azs             = local.azs
  private_subnets = local.private_subnets
  public_subnets  = local.public_subnets
  intra_subnets   = local.intra_subnets

  enable_nat_gateway = false
  enable_dns_hostnames = true
  enable_dns_support = true
  enable_vpn_gateway = true

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}