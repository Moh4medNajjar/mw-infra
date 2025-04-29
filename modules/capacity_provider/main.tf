locals {
  name_suffix = "${lookup(var.tags, "Environment")}-${lookup(var.tags, "Project")}"
}

resource "aws_security_group" "my_ssm-sg" {
  vpc_id = var.vpc_id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "ssm_sg-${local.name_suffix}"
    Owner       = lookup(var.tags, "Owner")
    Application = "security"
    Project     = lookup(var.tags, "Project")
    Environment = lookup(var.tags, "Environment")
  }
}

//*************************************************************************************************

resource "aws_iam_role" "my_ecs_instance_role" {
  name               = "ecs-instance-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "my_ecs_instance_role_attachments" {
  for_each = toset([
    "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role",
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  ])
  role       = aws_iam_role.my_ecs_instance_role.name
  policy_arn = each.value
}

resource "aws_iam_instance_profile" "my_ecs_instance_profile" {
  name = "ecs-instance-role"
  role = aws_iam_role.my_ecs_instance_role.name
}

//*************************************************************************************************

data "aws_ami" "my_ecs_ami" {
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-ecs-hvm-*-x86_64-ebs"]
  }
  owners = ["amazon"]
}

resource "aws_launch_template" "my_launch_template" {
  name                   = "lt-${local.name_suffix}"
  image_id               = data.aws_ami.my_ecs_ami.id
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.my_ssm-sg.id]

  iam_instance_profile {
    name = aws_iam_instance_profile.my_ecs_instance_profile.name
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name        = "ec2-${local.name_suffix}"
      Owner       = lookup(var.tags, "Owner")
      Application = "computing"
      Project     = lookup(var.tags, "Project")
      Environment = lookup(var.tags, "Environment")
    }
  }

  user_data = base64encode(<<-EOF
    #!/bin/bash
    echo ECS_CLUSTER=ecs-cluster-integ-mw >> /etc/ecs/ecs.config
  EOF
  )

  depends_on = [
    aws_iam_instance_profile.my_ecs_instance_profile
  ]
}

//**********************************************************************************************************************

resource "aws_autoscaling_group" "my_asg" {
  name                      = "asg-${local.name_suffix}"
  max_size                  = var.max_size
  min_size                  = var.min_size
  desired_capacity          = var.desired_capacity

  launch_template {
    id      = aws_launch_template.my_launch_template.id
    version = "$Latest"
  }

  vpc_zone_identifier = var.subnet_ids
  health_check_type   = "EC2"
  force_delete        = true
  //target_group_arns   = var.target_group_arns

  tag {
    key                 = "Name"
    value               = "asg-${local.name_suffix}"
    propagate_at_launch = false
  }

  depends_on = [
    aws_launch_template.my_launch_template
  ]
}

//**********************************************************************************************************************

resource "aws_ecs_capacity_provider" "my_cp" {
  name = "mw-ecs-cp-${local.name_suffix}"
  auto_scaling_group_provider {
    auto_scaling_group_arn         = aws_autoscaling_group.my_asg.arn
    managed_scaling {
      status                    = "ENABLED"
      target_capacity           = 90
      minimum_scaling_step_size = 1
      maximum_scaling_step_size = 10
      instance_warmup_period    = 300
    }
  }
  tags = {
    Name        = "ecs-cp-${local.name_suffix}"
    Owner       = lookup(var.tags, "Owner")
    Application = "computing" #lookup(var.tags, "Application")
    Project     = lookup(var.tags, "Project")
    Environment = lookup(var.tags, "Environment")
  }
  depends_on = [
    aws_autoscaling_group.my_asg
  ]
}
