variable "mw_cidr_block" {
  type = string
}

variable "tags" {}


variable "public_cidrs" {
  type = list(string)
}

variable "private_cidrs" {
  type = list(string)
}

variable "public_azs" {
  type = list(string)
}
variable "private_azs" {
  type = list(string)
}

variable "desired_capacity" {}
variable "instance_type" {}
variable "max_size" {}
variable "min_size" {}

# variable "container_name" {}
# variable "family" {}
# variable "container_port" {}
# variable "service_name" {}
variable "cpu" {}
variable "memory" {}
variable "desired_count" {}






variable "rds_allocated_storage" {}
variable "rds_instance_class" {}
variable "rds_username" {}
variable "password" {}

variable "s3_names" {}
variable "s3_versioning" {}



# variable "container_definitions" {}

variable "repo_names" {}
variable scan_on_push  {}



variable "bastion_instance_type" {}











variable "network_mode" {}
variable "launch_type" {}


variable "lg_name" {}
variable "lg_retention" {}


variable "ecs_tasks_list" {
  type = list(object({
    container_name        = string
    isFront               = bool
    container_port        = optional(number)
    container_definitions = string
    service_name          = string
    family                = string
  }))
}

