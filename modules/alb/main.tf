locals {
  name_suffix = "${lookup(var.tags, "Environment")}-${lookup(var.tags, "Project")}-${lookup(var.tags, "Application")}"
}

// *************************************************************************************************

resource "aws_security_group" "alb_sg" {
  name        = "alb-sg-${local.name_suffix}"
  description = "Allow HTTP and HTTPS"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTPS"
    from_port   = 443
    to_port     = 443
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
    Name        = "alb-sg-${local.name_suffix}"
    Owner       = lookup(var.tags, "Owner")
    Application = lookup(var.tags, "Application")
    Project     = lookup(var.tags, "Project")
    Environment = lookup(var.tags, "Environment")
  }
}

// *************************************************************************************************

resource "aws_lb" "mw_alb" {
  name               = "alb-${local.name_suffix}"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = var.subnet_ids

  tags = {
    Name        = "alb-${local.name_suffix}"
    Owner       = lookup(var.tags, "Owner")
    Application = lookup(var.tags, "Application")
    Project     = lookup(var.tags, "Project")
    Environment = lookup(var.tags, "Environment")
  }

  depends_on = [
    aws_security_group.alb_sg

  ]
}

// *************************************************************************************************

resource "aws_lb_target_group" "alb_tg" {
  name     = "alb-tg-${local.name_suffix}"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  target_type = "ip"

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200-299"
  }

  tags = {
    Name        = "alb-tg-${local.name_suffix}"
    Owner       = lookup(var.tags, "Owner")
    Application = lookup(var.tags, "Application")
    Project     = lookup(var.tags, "Project")
    Environment = lookup(var.tags, "Environment")
  }

  depends_on = [
    aws_lb.mw_alb
  ]
}

// *************************************************************************************************

resource "aws_lb_listener" "mw_listener" {
  load_balancer_arn = aws_lb.mw_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_tg.arn
  }

  tags = {
    Name        = "alb-listener-${local.name_suffix}"
    Owner       = lookup(var.tags, "Owner")
    Application = lookup(var.tags, "Application")
    Project     = lookup(var.tags, "Project")
    Environment = lookup(var.tags, "Environment")
  }

  /*depends_on = [
    aws_lb_target_group.alb_tg
  ]*/
}
