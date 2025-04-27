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

variable "container_name" {}

variable "container_port" {}

variable "cpu" {}

variable "desired_count" {}

variable "family" {}

variable "memory" {}
variable "service_name" {}

variable rds_allocated_storage {}
variable rds_instance_class {}
variable rds_username {}
variable password {}

variable s3_names {}
variable s3_versioning {}
