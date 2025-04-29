mw_cidr_block = "10.0.0.0/16"

tags = {
  Environment = "integ"
  Project     = "mw"
  Application = ["networking", "storage", "monitoring", "security","computing"]# networking / storage / monitoring / security /
  Owner       = "IT PEAC"
}

# storage_tags = {
#   Environment = "integ"
#   Project     = "mw"
#   Application = "mw" # networking / storage / monitoring / security /
#   Owner       = "IT PEAC"
# }
#
#
# tags = {
#   Environment = "integ"
#   Project     = "mw"
#   Application = "mw" # networking / storage / monitoring / security /
#   Owner       = "IT PEAC"
# }
#
# tags = {
#   Environment = "integ"
#   Project     = "mw"
#   Application = "mw" # networking / storage / monitoring / security /
#   Owner       = "IT PEAC"
# }




private_cidrs = ["10.0.96.0/19", "10.0.128.0/19", "10.0.160.0/19", "10.0.192.0/19"]
private_azs   = ["eu-west-3a", "eu-west-3a", "eu-west-3a", "eu-west-3b"]



public_cidrs = ["10.0.32.0/19", "10.0.64.0/19"]
public_azs   = ["eu-west-3a", "eu-west-3b"]



instance_type    = "t3.micro"
desired_capacity = 1
max_size         = 2
min_size         = 1


# container_name = "mw_app"
# container_port = 80
network_mode = "awsvpc"
launch_type = "EC2"
cpu           = 256
memory        = "512"
desired_count = 1
# family         = "mw-family"
# service_name          = "mw_app"

rds_allocated_storage = 20
rds_instance_class    = "db.t3.micro"
rds_username          = "admin_chaima_123456789"
password              = "itpeac123"

s3_names      = ["app-bukt", "log-bukt", "tfstate-bukt"]
s3_versioning = "Enabled"

repo_names = ["backend", "frontend"]
bastion_instance_type = "t3.micro"


scan_on_push = true

# lg_groups = [
#   {
#     lg_name = "ecs-task",
#     lg_retention = 90
#   },
#
# ]

lg_name = "/ecs/ecs-task-integ-mw-monitoring"
lg_retention = 90



ecs_tasks_list = [
  {
    container_name        = "mw_app"
    family                = "mw-family"
    isFront               = true
    container_port        = 80
    container_definitions = "./container_definitions/mw_container_def.json"
    service_name          = "mw_app"
  },
  {
    container_name        = "second"
    family                = "second"
    isFront               = false
    container_port        = 3000
    container_definitions = "./container_definitions/mw_container_def_second.json"
    service_name          = "second"
  }
]
