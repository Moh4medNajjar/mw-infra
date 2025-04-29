output "alb_dns_name" {
  value       = aws_lb.my_alb.dns_name
  description = "DNS name of the ALB"
}

output "alb_arn" {
  value       = aws_lb.my_alb.arn
  description = "ARN of the Application Load Balancer"
}

output "alb_security_group_id" {
  value       = aws_security_group.my_alb_sg.id
  description = "ID of the ALB security group"
}

output "alb_target_group_arn" {
  value       = aws_lb_target_group.my_alb_tg.arn
  description = "ARN of the ALB target group"
}

output "alb_listener_arn" {
  value       = aws_lb_listener.my_listener.arn
  description = "ARN of the ALB listener"
}
