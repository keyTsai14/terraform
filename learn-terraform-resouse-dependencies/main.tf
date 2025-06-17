provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region     = "ap-northeast-1"
}

resource "aws_s3_bucket" "example" {
    bucket = "key-learn-terraform"
    acl    = "private"
}

# resource <resource_type> <resource_name>
resource "aws_instance" "example" {
    ami             = "ami-0227b347afc3e5a45"
    instance_type   = "t2.micro"

    depends_on      = [ aws_s3_bucket.example ]
}

resource "aws_eip" "ip" {
  instance = aws_instance.example.id
}