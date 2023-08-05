#===============================================================================
# AWS EC2 KEY PAIR
#===============================================================================
variable "common_prefix" {
  type        = string
  description = "set commom prefix"
  default     = "k3s"
}
variable "environment" {
  type        = string
  description = "set up environment"
  default     = "dev"
}
variable "global_tags" {
  type        = map(string)
  description = "set global tags"
  default     = {}
}
variable "path_to_public_key" {
  type        = string
  description = "set path of public key"
}
#===============================================================================
# AWS EC2 STORAGE
#===============================================================================
variable "availability_zone" {
  type        = string
  description = "set availability zone"
  default     = null
}
variable "encrypted" {
  type        = bool
  description = "set encrypted"
  default     = true
}
variable "type" {
  type        = string
  description = "set type"
  default     = "gp2"
}
variable "size" {
  type        = number
  description = "set size"
  default     = 8
}
#===============================================================================
# AWS EC2 INSTANCE
#===============================================================================
variable "instance_type" {
  type        = string
  description = "set instance type"
  default     = "t4g.nano"
}
variable "user_data_path" {
  type        = string
  description = "set user data"
  default     = null
}

