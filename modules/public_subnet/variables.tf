
variable "vpc_id" {
  description = "vpc_id"
}

variable public_cidrs {
  type = list(string)
}

variable "azs" {
  type = list(string)
}

variable tags {}
variable public_rt {}
