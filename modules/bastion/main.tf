locals {
  name_suffix = "${lookup(var.tags, "Environment")}-${lookup(var.tags, "Project")}"
}
# Generate RSA key pair
resource "tls_private_key" "my_bh_tls_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "aws_s3_object" "my_private_key_pem" {
  bucket = var.bucketname
  key    = "key_bastion/key_bastion.pem"
  content = tls_private_key.my_bh_tls_key.private_key_pem
}

# Create AWS key pair
resource "aws_key_pair" "my_bh_tls_key_pair" {
  key_name   = "key_bastionhost"
  public_key = tls_private_key.my_bh_tls_key.public_key_openssh
}

data "aws_ami" "my_bastion_ami" {
  most_recent = true
  owners = ["amazon"]
  filter {
    name = "name"
    values = ["amzn2-ami-hvm-*"]
  }
  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }
}

  resource "aws_instance" "my_bastion_instance" {
  ami                         =data.aws_ami.my_bastion_ami.id
  instance_type               = var.bastion_instance_type
  vpc_security_group_ids      = [aws_security_group.my_bh_sg.id]
  subnet_id                   = var.subnet_id_public
  associate_public_ip_address = true
  key_name      = aws_key_pair.my_bh_tls_key_pair.key_name

  tags = {
    Name        = "bastion-host-${local.name_suffix}"
    Owner       = lookup(var.tags, "Owner")
    Application = "computing"
    Project     = lookup(var.tags, "Project")
    Environment = lookup(var.tags, "Environment")
  }
}

resource "aws_security_group" "my_bh_sg" {
  name   = "bh-sg-${local.name_suffix}"
  vpc_id = var.vpc_id

  ingress {
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = -1
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "bh-sg-${local.name_suffix}"
    Owner       = lookup(var.tags, "Owner")
    Application = "security"
    Project     = lookup(var.tags, "Project")
    Environment = lookup(var.tags, "Environment")
  }
}






































# data "aws_ami" "bastion_ami" {
#   most_recent = true
#   filter {
#     name   = "name"
#     values = ["amzn2-ami-ecs-hvm-*-x86_64-ebs"]
#   }
#   owners = ["amazon"]
# }