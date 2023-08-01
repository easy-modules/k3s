variable "common_prefix" {
  type    = string
  description = "set commom prefix"
  default = "k3s"
}

variable "environment" {
  type = string
  description = "set up environment"
  default = "dev"
}

variable "global_tags" {
  type = map(string)
  description = "set global tags"
  default = {}
}

variable "PATH_TO_PUBLIC_KEY" {
  type = string
  description = "set path of public key"
}