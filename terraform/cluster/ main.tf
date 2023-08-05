data "aws_availability_zones" "available" {}

locals {
  azs = data.aws_availability_zones.available.names
  default_tags = {
      CreatedBy   = "Terraform"
  }
}
#===============================================================================
# AWS EC2 KEY PAIR
#===============================================================================
resource "null_resource" "create_keys" {
  provisioner "local-exec" {
    command = "devopstation create keys"
  }
}
resource "aws_ssm_parameter" "private_key" {
  depends_on = [null_resource.create_keys]
  name = "/K3S/${upper(var.environment)}PRIVATE_KEY"
  description = "Private key for K3S"
  type = "string"
  value = file("${path.module}/private_key")
}
resource "aws_ssm_parameter" "public_key" {
  depends_on = [null_resource.create_keys]
  name = "/K3S/${upper(var.environment)}PUBLIC_KEY"
  description = "Public key for K3S"
  type = "string"
  value = file("${path.module}/public_key")
}
resource "null_resource" "remove_keys" {
  triggers = {
    private_key = aws_ssm_parameter.private_key.value
    public_key = aws_ssm_parameter.public_key.value
  }

  provisioner "local-exec" {
    command = "devopstation remove keys"
  }
}
resource "aws_key_pair" "my_ssh_public_key" {
  key_name   = "${var.common_prefix}-ssh-pubkey-${var.environment}"
  public_key = aws_ssm_parameter.public_key.value

  tags = merge(
    local.default_tags,
    {
      Name = lower("${var.common_prefix}-ssh-pubkey-${var.environment}")
    }
  )
}
#===============================================================================
# AWS EC2 EBS
#===============================================================================
resource "aws_ebs_volume" "ebs" {
  availability_zone = var.availability_zone == null ? var.availability_zone : local.azs[0] ## us-west-2a
  encrypted         = var.encrypted
  type              = var.type
  size              = var.size
  tags              = merge(
    local.default_tags,
    { Name = format("%s-ebs-%s", var.common_prefix, var.environment) }
  )
}
#===============================================================================
# AWS EC2 INSTANCE
#===============================================================================
locals {
  user_data = fileexists(var.user_data_path) ? file(var.user_data_path) : file("${path.module}/scripts/user_data.sh")
}
data "aws_ami" "amazon" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["al2023-ami-2023*"]
  }
  filter {
    name   = "architecture"
    values = ["arm64"]
  }

}
resource "aws_instance" "ec2" {
  ami           = data.aws_ami.amazon.id
  instance_type = var.instance_type
  user_data     = local.user_data
  key_name      = aws_key_pair.my_ssh_public_key.key_name
  tags = merge(
    local.default_tags,
    { Name = lower(format("%s-ec2-%s", var.common_prefix, var.environment)) }
  )
}
#===============================================================================
# AWS EC2 EBS ATTACHMENT
#===============================================================================
resource "aws_volume_attachment" "ebs_att" {
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.ebs.id
  instance_id = aws_instance.ec2.id
}