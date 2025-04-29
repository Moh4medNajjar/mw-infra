locals {

  name_suffix = "${lookup(var.tags, "Environment")}-${lookup(var.tags, "Project")}"
}

resource "aws_subnet" "my_private_subnet" {
  count                    = length(var.private_cidrs)
  vpc_id                   = var.vpc_id
  cidr_block               = var.private_cidrs[count.index]
  availability_zone        = var.azs[count.index]
  map_public_ip_on_launch  = false

  tags = {
    Name        = "prs-${count.index + 1}-${local.name_suffix}"
    Owner       = lookup(var.tags, "Owner")
    Application ="networking"
    Project     = lookup(var.tags, "Project")
    Environment = lookup(var.tags, "Environment")
  }
}

resource "aws_route_table_association" "my_private_assoc" {
  count          = length(var.private_cidrs)
  subnet_id      = aws_subnet.my_private_subnet[count.index].id
  route_table_id = var.private_rt
  depends_on = [aws_subnet.my_private_subnet]
}
