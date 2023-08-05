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

resource "aws_security_group" "allow_strict" {
  vpc_id      = var.vpc_id
  name        = "${var.common_prefix}-allow-strict-${var.environment}"
  description = "security group that allows ssh and all egress traffic"

  tags = merge(
    local.global_tags,
    {
      "Name" = lower("${var.common_prefix}-allow-strict-${var.environment}")
    }
  )
}

#resource "aws_security_group_rule" "ingress_self" {
#  type              = "ingress"
#  from_port         = 0
#  to_port           = 0
#  protocol          = "-1"
#  self              = true
#  security_group_id = aws_security_group.allow_strict.id
#}
#
#resource "aws_security_group_rule" "ingress_kubeapi" {
#  type              = "ingress"
#  from_port         = var.kube_api_port
#  to_port           = var.kube_api_port
#  protocol          = "tcp"
#  cidr_blocks       = [var.vpc_subnet_cidr]
#  security_group_id = aws_security_group.allow_strict.id
#}
#
#resource "aws_security_group_rule" "ingress_ssh" {
#  type              = "ingress"
#  from_port         = 22
#  to_port           = 22
#  protocol          = "tcp"
#  cidr_blocks       = [var.my_public_ip_cidr]
#  security_group_id = aws_security_group.allow_strict.id
#}
#
#resource "aws_security_group_rule" "egress_all" {
#  type              = "egress"
#  from_port         = 0
#  to_port           = 0
#  protocol          = "-1"
#  cidr_blocks       = ["0.0.0.0/0"]
#  security_group_id = aws_security_group.allow_strict.id
#}
#
#resource "aws_security_group_rule" "allow_lb_http_traffic" {
#  count             = var.create_extlb ? 1 : 0
#  type              = "ingress"
#  from_port         = var.extlb_http_port
#  to_port           = var.extlb_http_port
#  protocol          = "tcp"
#  cidr_blocks       = ["0.0.0.0/0"]
#  security_group_id = aws_security_group.allow_strict.id
#}
#
#resource "aws_security_group_rule" "allow_lb_https_traffic" {
#  count             = var.create_extlb ? 1 : 0
#  type              = "ingress"
#  from_port         = var.extlb_https_port
#  to_port           = var.extlb_https_port
#  protocol          = "tcp"
#  cidr_blocks       = ["0.0.0.0/0"]
#  security_group_id = aws_security_group.allow_strict.id
#}
#
#resource "aws_security_group_rule" "allow_lb_kubeapi_traffic" {
#  count             = var.create_extlb && var.expose_kubeapi ? 1 : 0
#  type              = "ingress"
#  from_port         = var.kube_api_port
#  to_port           = var.kube_api_port
#  protocol          = "tcp"
#  cidr_blocks       = [var.my_public_ip_cidr]
#  security_group_id = aws_security_group.allow_strict.id
#}
#
#resource "aws_security_group" "efs_sg" {
#  count       = var.efs_persistent_storage ? 1 : 0
#  vpc_id      = var.vpc_id
#  name        = "${var.common_prefix}-efs-sg-${var.environment}"
#  description = "Allow EFS access from VPC subnets"
#
#  egress {
#    from_port   = 0
#    to_port     = 0
#    protocol    = "-1"
#    cidr_blocks = ["0.0.0.0/0"]
#  }
#
#  ingress {
#    from_port   = 2049
#    to_port     = 2049
#    protocol    = "tcp"
#    cidr_blocks = [var.vpc_subnet_cidr]
#  }
#
#  tags = merge(
#    local.global_tags,
#    {
#      "Name" = lower("${var.common_prefix}-efs-sg-${var.environment}")
#    }
#  )
#}
#
#resource "aws_security_group" "lambda_sg" {
#  vpc_id      = var.vpc_id
#  name        = "${var.common_prefix}-lambda-sg-${var.environment}"
#  description = "Allow lambda function to access kubeapi"
#
#  egress {
#    from_port   = 0
#    to_port     = 0
#    protocol    = "-1"
#    cidr_blocks = ["0.0.0.0/0"]
#  }
#
#  ingress {
#    from_port   = var.kube_api_port
#    to_port     = var.kube_api_port
#    protocol    = "tcp"
#    cidr_blocks = [var.vpc_subnet_cidr]
#  }
#
#  ingress {
#    protocol  = "-1"
#    self      = true
#    from_port = 0
#    to_port   = 0
#  }
#
#  tags = merge(
#    local.global_tags,
#    {
#      "Name" = lower("${var.common_prefix}-lambda-sg-${var.environment}")
#    }
#  )
#}
#
#resource "aws_security_group" "internal_vpce_sg" {
#  vpc_id      = var.vpc_id
#  name        = "${var.common_prefix}-int-vpce-sg-${var.environment}"
#  description = "Allow all traffic trought vpce"
#
#  egress {
#    from_port   = 0
#    to_port     = 0
#    protocol    = "-1"
#    cidr_blocks = [var.vpc_subnet_cidr]
#  }
#
#  ingress {
#    from_port   = 0
#    to_port     = 0
#    protocol    = "-1"
#    cidr_blocks = [var.vpc_subnet_cidr]
#  }
#
#  ingress {
#    protocol  = "-1"
#    self      = true
#    from_port = 0
#    to_port   = 0
#  }
#
#  tags = merge(
#    local.global_tags,
#    {
#      "Name" = lower("${var.common_prefix}-int-vpce-sg-${var.environment}")
#    }
#  )
#}