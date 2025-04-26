locals {
  name_suffix = "${lookup(var.tags, "Environment")}-${lookup(var.tags, "Project")}-${lookup(var.tags, "Application")}"
}

resource "aws_eip" "mw_eip" {
  tags = {
    Name        = "eip-${local.name_suffix}"
    Owner       = lookup(var.tags, "Owner")
    Application = lookup(var.tags, "Application")
    Project     = lookup(var.tags, "Project")
    Environment = lookup(var.tags, "Environment")
  }
}

resource "aws_nat_gateway" "mw_nat_gateway" {
  allocation_id = aws_eip.mw_eip.id
  subnet_id     = var.public_subnet_id

  tags = {
    Name        = "nat-gateway-${local.name_suffix}"
    Owner       = lookup(var.tags, "Owner")
    Application = lookup(var.tags, "Application")
    Project     = lookup(var.tags, "Project")
    Environment = lookup(var.tags, "Environment")
  }

  depends_on = [aws_eip.mw_eip]
}

resource "aws_route_table" "mw_private_rt" {
  vpc_id = var.vpc_id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.mw_nat_gateway.id
  }

  tags = {
    Name        = "pr_rt-${local.name_suffix}"
    Owner       = lookup(var.tags, "Application")
    Application = lookup(var.tags, "Application")
    Project     = lookup(var.tags, "Project")
    Environment = lookup(var.tags, "Environment")
  }

  depends_on = [aws_nat_gateway.mw_nat_gateway]
}
