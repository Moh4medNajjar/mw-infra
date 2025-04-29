output "bastion_instance_id" {
  description = "The ID of the bastion host instance"
  value       = aws_instance.my_bastion_instance.id
}

output "bastion_public_ip" {
  description = "The public IP of the bastion host instance"
  value       = aws_instance.my_bastion_instance.public_ip
}