output "subnet_ids" {
  value       = aws_subnet.public_subnet[*].id
  description = "List of all public subnet IDs"
}