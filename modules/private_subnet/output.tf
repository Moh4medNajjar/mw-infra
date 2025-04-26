output "subnet_ids" {
  value       = aws_subnet.private_subnet[*].id
  description = "List of all private subnet IDs"
}