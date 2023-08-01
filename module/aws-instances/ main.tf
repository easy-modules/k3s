locals {
    default_tags = {
        Environment = var.environment == null ? "" : var.environment
        Owner       = var.owner == null ? "" : var.owner
        Project     = var.project == null ? "" : var.project
        CreatedBy   = "Terraform"
    }
}
#===============================================================================
# AWS EC2
#===============================================================================
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
resource "aws_key_pair" "my_ssh_public_key" {
  key_name   = "${var.common_prefix}-ssh-pubkey-${var.environment}"
  public_key = file(var.PATH_TO_PUBLIC_KEY)

  tags = merge(
    local.default_tags,
    {
      "Name" = lower("${var.common_prefix}-ssh-pubkey-${var.environment}")
    }
  )
}
resource "aws_ebs_volume" "ebs" {
  availability_zone = var.availability_zone ## us-west-2a
  encrypted         = true
  type              = "gp2"
  size              = 8
  tags              = merge(
    local.default_tags,
    { Name = format("%s-ebs-%s", ) }
  )
}
resource "aws_instance" "ec2" {
  ami           = data.aws_ami.amazon.id
  instance_type = "t4g.nano"
  user_data     = ""
  tags = {
    Name = "k3s-server"
  }
}
resource "aws_volume_attachment" "ebs_att" {
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.ebs.id
  instance_id = aws_instance.ec2.id

}
