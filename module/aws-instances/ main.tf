
#===============================================================================
# KEY PAIR
#===============================================================================
resource "aws_key_pair" "my_ssh_public_key" {
  key_name   = "${var.common_prefix}-ssh-pubkey-${var.environment}"
  public_key = file(var.PATH_TO_PUBLIC_KEY)

  tags = merge(
    local.global_tags,
    {
      "Name" = lower("${var.common_prefix}-ssh-pubkey-${var.environment}")
    }
  )
}

#===============================================================================
# AWS EBS
#===============================================================================
resource "aws_ebs_volume" "ebs" {
  availability_zone = var.availability_zone ## us-west-2a
  encrypted = true
  type = gp2
  size              = 8
  tags = { Name = "k3s-volume" }
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

resource "aws_instance" "ec2" {
    ami = data.aws_ami.amazon.id
    instance_type = "t4g.nano"
    user_data = ""
    

    tags = {
        Name = "k3s-server"
    }
}