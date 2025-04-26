output "vpc_id" {
  value       = aws_vpc.vpc.id
  description = "The ID of the main VPC"
}

output "igw_id" {
  value       = aws_internet_gateway.mw_igw.id
  description = "The ID of the internet gateway"
}

output "public_rt_id" {
  value       = aws_route_table.mw_public_rt.id
  description = "The ID of the public route table"
}
