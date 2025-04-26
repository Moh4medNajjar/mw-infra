variable "family" {}
variable "container_definitions" {}
variable "cpu" {}
variable "memory" {}
variable "service_name" {}
variable "cluster_name" {}
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
  type = number
}