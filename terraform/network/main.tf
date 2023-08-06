#===============================================================================
# AWS VIRTUAL PRIVATE CLOUD
#===============================================================================
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "4.0.1"

  name = "k3s-vpc"
  cidr = "192.168.0.0/16"

  azs            = ["eu-west-1a", "eu-west-1b"]
  public_subnets = ["192.168.4.0/24", "192.168.5.0/24"]

  enable_nat_gateway   = false
  enable_dns_hostnames = true

  tags = {
    "Terraform" = "true"
    "Project"   = "workstation"
  }
}
#===============================================================================
# AWS EXTERNAL SECURITY GROUP
#===============================================================================
resource "aws_security_group" "external_sg" {
  vpc_id      = module.vpc.vpc_id
  name        = "${var.common_prefix}-external-sg-${var.environment}"
  description = "security group that allows ssh and all egress traffic"

  tags = merge(
    {
      "Name" = lower("${var.common_prefix}-external-sg-${var.environment}")
    }
  )
}

resource "aws_security_group_rule" "external_ingress" {
  count             = length(var.external_ingress_group_rules)
  type              = "ingress"
  from_port         = var.external_ingress_group_rules[count.index].from_port
  to_port           = var.external_ingress_group_rules[count.index].to_port
  protocol          = var.external_ingress_group_rules[count.index].protocol
  cidr_blocks       = lookup(var.external_ingress_group_rules[count.index].cidr_block, "cidr_blocks", null )
  description       = lookup(var.external_ingress_group_rules[count.index].description,"description" null)
  security_group_id = aws_security_group.external_sg.id
}

resource "aws_security_group_rule" "external_egress" {
  count             = length(var.external_egress_group_rules)
  type              = "egress"
  from_port         = var.external_egress_group_rules[count.index].from_port
  to_port           = var.external_egress_group_rules[count.index].to_port
  protocol          = var.external_egress_group_rules[count.index].protocol
  cidr_blocks       = lookup(var.external_egress_group_rules[count.index].cidr_block, "cidr_blocks", null )
  description       = lookup(var.external_egress_group_rules[count.index].description,"description" null)
  security_group_id = aws_security_group.external_sg.id
}
#===============================================================================
# AWS INTERNAL SECURITY GROUP
#===============================================================================
resource "aws_security_group" "internal_sg" {
  vpc_id      = module.vpc.vpc_id
  name        = "${var.common_prefix}-internal-sg-${var.environment}"
  description = "security group that allows ssh and all egress traffic"

  tags = merge(
    {
      "Name" = lower("${var.common_prefix}-internal-sg-${var.environment}")
    }
  )
}

resource "aws_security_group_rule" "internal_ingress" {
  count             = length(var.internal_ingress_group_rules)
  type              = "ingress"
  from_port         = var.internal_ingress_group_rules[count.index].from_port
  to_port           = var.internal_ingress_group_rules[count.index].to_port
  protocol          = var.internal_ingress_group_rules[count.index].protocol
  cidr_blocks       = lookup(var.internal_ingress_group_rules[count.index].cidr_block, "cidr_blocks", null )
  description       = lookup(var.internal_ingress_group_rules[count.index].description,"description" null)
  security_group_id = aws_security_group.internal_sg.id
}

resource "aws_security_group_rule" "internal_egress" {
  count             = length(var.internal_egress_group_rules)
  type              = "egress"
  from_port         = var.internal_egress_group_rules[count.index].from_port
  to_port           = var.internal_egress_group_rules[count.index].to_port
  protocol          = var.internal_egress_group_rules[count.index].protocol
  cidr_blocks       = lookup(var.internal_egress_group_rules[count.index].cidr_block, "cidr_blocks", null )
  description       = lookup(var.internal_egress_group_rules[count.index].description,"description" null)
  security_group_id = aws_security_group.internal_sg.id
}

