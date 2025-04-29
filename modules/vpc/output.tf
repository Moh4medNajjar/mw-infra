output "vpc_id" {
  value       = aws_vpc.my_vpc.id
  description = "The ID of the main VPC"
}

output "igw_id" {
  value       = aws_internet_gateway.my_igw.id
  description = "The ID of the internet gateway"
}

output "public_rt_id" {
  value       = aws_route_table.my_public_rt.id
  description = "The ID of the public route table"
}
