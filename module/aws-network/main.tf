data "aws_availability_zones" "available" {}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "4.0.1"

  name            = "k3s-vpc"
  cidr            = "192.168.0.0/16"

  azs             = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  public_subnets  = ["192.168.4.0/24", "192.168.5.0/24", "192.168.6.0/24"]
  
  enable_nat_gateway = false
  enable_dns_hostnames = true

  tags = {
    "Terraform"   = "true"
    "Project" = "workstation"
  }

}

