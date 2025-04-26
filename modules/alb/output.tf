output "alb_dns_name" {
  value       = aws_lb.mw_alb.dns_name
  description = "DNS name of the ALB"
}

output "alb_arn" {
  value       = aws_lb.mw_alb.arn
  description = "ARN of the Application Load Balancer"
}

output "alb_security_group_id" {
  value       = aws_security_group.alb_sg.id
  description = "ID of the ALB security group"
}

output "alb_target_group_arn" {
  value       = aws_lb_target_group.alb_tg.arn
  description = "ARN of the ALB target group"
}

output "alb_listener_arn" {
  value       = aws_lb_listener.mw_listener.arn
  description = "ARN of the ALB listener"
}
