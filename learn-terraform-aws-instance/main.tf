terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "ap-northeast-1"
}

resource "aws_instance" "app_server" {
  ami           = "ami-0227b347afc3e5a45"
  instance_type = "t2.micro"

  tags = {
    Name = "ExampleAppServerInstance"
  }
}