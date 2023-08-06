terraform {
  required_version = ">= 1.0.0"
  required_providers {}

  backend "s3" {
    bucket  = ""
    encrypt = true
    key     = ""
  }
}