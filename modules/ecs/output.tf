output "ecs_cluster_id" {
  value       = aws_ecs_cluster.mw_ecs_cluster.id
  description = "The ECS Cluster ID"
}

output "ecs_cluster_name" {
  value       = aws_ecs_cluster.mw_ecs_cluster.name
  description = "The ECS Cluster Name"
}

output "ecs_cluster_arn" {
  value       = aws_ecs_cluster.mw_ecs_cluster.arn
  description = "The ARN of the ECS cluster"
}
