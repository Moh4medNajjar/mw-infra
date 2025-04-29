variable "family" {}
variable "container_definitions" {}
variable "cpu" {}
variable "memory" {}
variable "network_mode" {}



variable "service_name" {}
variable "cluster_name" {}
variable "launch_type" {}

variable "desired_count" {}
variable "capacity_provider_name" {}
variable "subnet_ids" {
  type = list(string)
}
variable "target_group_arn" {}
variable "alb_listener_arn" {}
variable "container_name" {}
variable "tags" {}
variable "vpc_id" {}
variable "container_port" {
}

variable isFront {}

variable ecs_tasks_list {}
