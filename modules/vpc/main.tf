locals {

  name_suffix = "${lookup(var.tags, "Environment")}-${lookup(var.tags, "Project")}"

}

resource "aws_vpc" "my_vpc" {
  cidr_block = var.cidr_block

  tags = {
    Name        = "vpc-${local.name_suffix}"
    Owner       = lookup(var.tags, "Owner")
    Application = "networking" #lookup(var.tags, "Application")
    Project     = lookup(var.tags, "Project")
    Environment = lookup(var.tags, "Environment")
  }
}

resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name        = "igw-${local.name_suffix}"
    Owner       = lookup(var.tags, "Owner")
    Application = "networking"
    Project     = lookup(var.tags, "Project")
    Environment = lookup(var.tags, "Environment")
  }

  depends_on = [aws_vpc.my_vpc]
}

resource "aws_route_table" "my_public_rt" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_igw.id
  }

  tags = {
    Name        = "pb_rt-${local.name_suffix}"
    Owner       = lookup(var.tags, "Owner")
    Application = "networking"
    Project     = lookup(var.tags, "Project")
    Environment = lookup(var.tags, "Environment")
  }

  depends_on = [aws_internet_gateway.my_igw]
}
