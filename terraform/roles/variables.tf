variable "environment" {
  type        = string
  description = "set up environment"
  default     = "dev"
}

variable "common_prefix" {
  type        = string
  description = "set commom prefix"
  default     = "k3s"
}

variable "global_tags" {
  type        = map(string)
  description = "set global tags"
  default     = {}
}

