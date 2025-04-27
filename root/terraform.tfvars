mw_cidr_block = "10.0.0.0/16"

tags = {
  Environment = "integ"
  Project     = "app-eg"
  Application = "mw"
  Owner       = "IT PEAC"
}

private_cidrs = ["10.0.96.0/19", "10.0.128.0/19", "10.0.160.0/19"]
private_azs   = ["eu-west-3a", "eu-west-3a", "eu-west-3a"]

public_cidrs = ["10.0.32.0/19", "10.0.64.0/19"]
public_azs   = ["eu-west-3a", "eu-west-3b"]

desired_capacity = 1

instance_type = "t3.micro"

max_size = 2

min_size = 1

container_name = "mw_app"
container_port = 80
cpu            = 256
memory         = "512"
desired_count  = 1
family         = "mw-family"
service_name   = "mw-service"

