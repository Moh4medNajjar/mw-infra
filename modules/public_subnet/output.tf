output "subnet_ids" {
  description = "List of all public subnet IDs"
  value       = aws_subnet.my_public_subnet[*].id
}