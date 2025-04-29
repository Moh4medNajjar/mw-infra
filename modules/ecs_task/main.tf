locals {
  name_suffix = "${lookup(var.tags, "Environment")}-${lookup(var.tags, "Project")}"
}

# resource "aws_ecs_task_definition" "my_ecs_task" {
#   family                  = var.family
#   container_definitions   = var.container_definitions
#   requires_compatibilities = ["EC2"]
#   network_mode            = var.network_mode
#   cpu                     = var.cpu
#   memory                  = var.memory
#   execution_role_arn      = aws_iam_role.my_execution_role.arn
#   task_role_arn           = aws_iam_role.my_task_role.arn
#
#   tags = {
#     Name        = "ecs-task-${local.name_suffix}"
#     Owner       = lookup(var.tags, "Owner")
#     Application = "computing" #lookup(var.tags, "Application")
#     Project     = lookup(var.tags, "Project")
#     Environment = lookup(var.tags, "Environment")
#   }
#
#   depends_on = [aws_iam_role.my_execution_role, aws_iam_role.my_task_role]
# }

//***********************************************************************
resource "aws_security_group" "my_ecs_task_sg" {
  name_prefix = "ecs-task-sg"
  description = "SG for ECS tasks"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name        = "ecs_task-sg-${local.name_suffix}"
    Owner       = lookup(var.tags, "Owner")
    Application = "security"
    Project     = lookup(var.tags, "Project")
    Environment = lookup(var.tags, "Environment")
  }
}

//***********************************************************************

resource "aws_iam_role" "my_execution_role" {
  name = "task-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name        = "exec-role-${local.name_suffix}"
    Owner       = lookup(var.tags, "Owner")
    Application = "security" #lookup(var.tags, "Application")
    Project     = lookup(var.tags, "Project")
    Environment = lookup(var.tags, "Environment")
  }
}

resource "aws_iam_role_policy_attachment" "my_execution_policy" {
  role       = aws_iam_role.my_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}



resource "aws_iam_role" "my_task_role" {
  name = "ecs-task-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })
  tags = {
    Name        = "task_role-${local.name_suffix}"
    Owner       = lookup(var.tags, "Owner")
    Application = "security" #lookup(var.tags, "Application")
    Project     = lookup(var.tags, "Project")
    Environment = lookup(var.tags, "Environment")
  }
}

resource "aws_iam_role_policy_attachment" "my_ecs_task_role_attachments" {
  for_each = toset([
    "arn:aws:iam::aws:policy/AmazonS3FullAccess",
    "arn:aws:iam::aws:policy/AmazonSESFullAccess",
    "arn:aws:iam::aws:policy/AmazonSQSFullAccess",
    "arn:aws:iam::aws:policy/AmazonSNSFullAccess",
    "arn:aws:iam::aws:policy/AmazonRDSFullAccess",
    "arn:aws:iam::aws:policy/service-role/AmazonDMSCloudWatchLogsRole"
  ])

  role       = aws_iam_role.my_task_role.name
  policy_arn = each.value
}





resource "aws_ecs_task_definition" "my_ecs_task" {
  count = length(var.ecs_tasks_list)
  family                  = var.family[count.index]
  container_definitions   = file(var.container_definitions[count.index])
  requires_compatibilities = ["EC2"]
  network_mode            = var.network_mode
  cpu                     = var.cpu
  memory                  = var.memory
  execution_role_arn      = aws_iam_role.my_execution_role.arn
  task_role_arn           = aws_iam_role.my_task_role.arn

  tags = {
    Name        = "ecs-task-${local.name_suffix}"
    Owner       = lookup(var.tags, "Owner")
    Application = "computing"
    Project     = lookup(var.tags, "Project")
    Environment = lookup(var.tags, "Environment")
  }

  depends_on = [aws_iam_role.my_execution_role, aws_iam_role.my_task_role]
}



resource "aws_ecs_service" "my_ecs_service" {
  count            = length(var.ecs_tasks_list)
  name             = var.service_name[count.index]
  cluster          = var.cluster_name
  task_definition  = aws_ecs_task_definition.my_ecs_task[count.index].arn
  desired_count    = var.desired_count
  launch_type      = var.launch_type

  network_configuration {
    subnets          = var.subnet_ids
    security_groups  = [aws_security_group.my_ecs_task_sg.id]
    assign_public_ip = false
  }

  dynamic "load_balancer" {
    for_each = var.isFront[count.index] ? [1] : []
    content {
      target_group_arn = var.target_group_arn
      container_name   = var.container_name[count.index]
      container_port   = var.container_port[count.index]
    }
  }

  tags = {
    Name        = "ecs-service-${local.name_suffix}-${count.index}"
    Owner       = lookup(var.tags, "Owner")
    Application = "computing"
    Project     = lookup(var.tags, "Project")
    Environment = lookup(var.tags, "Environment")
  }

}


