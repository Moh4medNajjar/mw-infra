locals {
  name_suffix = "${lookup(var.tags, "Environment")}-${lookup(var.tags, "Project")}"
}

resource "aws_subnet" "my_public_subnet" {
  count                    = length(var.public_cidrs)
  vpc_id                   = var.vpc_id
  cidr_block               = var.public_cidrs[count.index]
  availability_zone        = var.azs[count.index]
  map_public_ip_on_launch  = true
  tags = {
    Name        = "pbs-${count.index + 1}-${local.name_suffix}"
    Owner       = lookup(var.tags, "Owner")
    Application = "networking" #lookup(var.tags, "Application")
    Project     = lookup(var.tags, "Project")
    Environment = lookup(var.tags, "Environment")
  }
}

resource "aws_route_table_association" "my_public_assoc" {
  count          = length(var.public_cidrs)
  subnet_id      = aws_subnet.my_public_subnet[count.index].id
  route_table_id = var.public_rt

  depends_on = [aws_subnet.my_public_subnet]
}
