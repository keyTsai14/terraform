provider "aws" {
  region = var.region
}

data "aws_availability_zones" "available" {}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "6.0.0"


  name                 = "free-tier-vpc"
  cidr                 = "10.0.0.0/16"
  azs                  = data.aws_availability_zones.available.names
  private_subnets      = ["10.0.1.0/24", "10.0.2.0/24"]
  enable_dns_support   = true
  enable_dns_hostnames = true
}

resource "aws_db_subnet_group" "mysql" {
  name       = "mysql-subnet-group"
  subnet_ids = module.vpc.private_subnets

  tags = {
    Name = "mysql-subnet-group"
  }
}

resource "aws_security_group" "mysql_sg" {
  name   = "mysql_sg"
  vpc_id = module.vpc.vpc_id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [var.my_ip_cidr] # 👈 only allow YOUR IP
  }

  egress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"  # Specific protocol instead of "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "mysql-sg"
  }
}

resource "aws_db_parameter_group" "mysql" {
  name   = "mysql-parameter-group"
  family = "mysql8.0" # ← Change to appropriate family for your MySQL version

  parameter {
    name  = "slow_query_log"
    value = "1"
  }

  parameter {
    name  = "long_query_time"
    value = "2"
  }
}

resource "aws_db_instance" "mysql" {
  identifier              = "free-tier-mysql"
  instance_class          = "db.t3.micro"
  allocated_storage       = 20 # MySQL minimum recommended size
  engine                  = "mysql"
  engine_version          = "8.0.35" # ← Choose a supported MySQL version
  db_subnet_group_name    = aws_db_subnet_group.mysql.name
  vpc_security_group_ids  = [aws_security_group.mysql_sg.id]
  parameter_group_name    = aws_db_parameter_group.mysql.name
  publicly_accessible     = false
  backup_retention_period = 7
  skip_final_snapshot     = true

  username = "admin"
  password = var.db_password
}