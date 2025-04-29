locals {
  name_suffix = "${lookup(var.tags, "Environment")}-${lookup(var.tags, "Project")}"
}

resource "aws_security_group" "my_rds_sg" {
  name_prefix = "rds_sg"
  description = "SG for RDS instance"
  vpc_id      = var.vpc_id
  ingress {
    from_port   =5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name        = "rds-sg-${local.name_suffix}"
    Owner       = lookup(var.tags, "Owner")
    Application = "security"
    Project     = lookup(var.tags, "Project")
    Environment = lookup(var.tags, "Environment")
  }
}

data "aws_rds_engine_version" "my_latest_postgres" {
  engine = "postgres"
  preferred_versions = ["17.3"]
}


resource "aws_db_subnet_group" "my_rds_sb_gr" {
  name       = "rds-sb-gr-${local.name_suffix}"
  subnet_ids = var.subnets_id_rds

  tags = {
    Name        = "rds-sb-gr-${local.name_suffix}"
    Owner       = lookup(var.tags, "Owner")
    Application = "networking"
    Project     = lookup(var.tags, "Project")
    Environment = lookup(var.tags, "Environment")
  }
}

resource "aws_db_instance" "my_rds" {
  identifier_prefix = "rds-mw-${local.name_suffix}"
  engine                  = "postgres"
  engine_version          = data.aws_rds_engine_version.my_latest_postgres.id #var.engine_version
  allocated_storage       = var.allocated_storage
  instance_class          = var.instance_class
  username                = var.username
  password                = var.password
  //manage_master_user_password   = true
  //master_user_secret_kms_key_id = null
  db_subnet_group_name    = aws_db_subnet_group.my_rds_sb_gr.name
  vpc_security_group_ids = [aws_security_group.my_rds_sg.id]
  multi_az = false
  skip_final_snapshot     = true
  tags = {
    Name        = "rds-${local.name_suffix}"
    Owner       = lookup(var.tags, "Owner")
    Application = "storage"
    Project     = lookup(var.tags, "Project")
    Environment = lookup(var.tags, "Environment")
  }
}