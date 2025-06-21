resource "aws_ecr_repository" "terraform_app" {
  name = "terraform_app"
  image_scanning_configuration {
    scan_on_push = true
  }
  tags = {
    Name = "terraform_app"
  }
}
