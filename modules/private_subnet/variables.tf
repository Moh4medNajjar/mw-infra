
variable "vpc_id" {
  description = "vpc_id"
}

variable private_cidrs {
  type = list(string)
}

variable "azs" {
  type = list(string)
}

variable tags {}
variable private_rt {}
