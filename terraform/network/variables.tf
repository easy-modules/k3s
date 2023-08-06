variable "common_prefix" {
  type = string
  default = "k3s"
  description = "prefix name for network"
}

variable "environment" {
  type = string
  default = "default"
  description = "set environment name"
}
#===============================================================================
# AWS EXTERNAL SECURITY GROUP
#===============================================================================
variable "external_ingress_group_rules" {
  description = "Security group ingress"
  type        = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    description = string
    cidr_block  = list(string)
  }))
  default = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_block  = ["0.0.0.0/0"]
      description = "Allow SSH port"
    },
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_block  = ["0.0.0.0/0"]
      description = "Allow HTTP port"
    },
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_block  = ["0.0.0.0/0"]
      description = "Allow HTTPS port"
    }

  ]
}

variable "external_egress_group_rules" {
  description = "Security group egress"
  type        = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    description = string
    cidr_block  = list(string)
  }))
  default = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_block  = ["0.0.0.0/0"]
      description = "Allow all ports"
    },
  ]
}
#===============================================================================
# AWS INTERNAL SECURITY GROUP
#===============================================================================
variable "internal_ingress_group_rules" {
  description = "Security group ingress"
  type        = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    description = string
    cidr_block  = list(string)
  }))
  default = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_block  = ["0.0.0.0/0"]
      description = "Allow SSH port"
    },
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_block  = ["0.0.0.0/0"]
      description = "Allow HTTP port"
    },
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_block  = ["0.0.0.0/0"]
      description = "Allow HTTPS port"
    }

  ]
}

variable "internal_egress_group_rules" {
  description = "Security group egress"
  type        = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    description = string
    cidr_block  = list(string)
  }))
  default = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_block  = ["0.0.0.0/0"]
      description = "Allow all ports"
    },
  ]
}
