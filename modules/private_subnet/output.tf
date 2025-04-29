output "subnet_ids" {
  description = "List of all private subnet IDs"
  value       = aws_subnet.my_private_subnet[*].id
}