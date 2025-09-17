locals {
  environment = "prod"
  aws_region  = "us-east-1"

  # 多账号：使用本机 AWS profile
  aws_profile = "prod"

  tags = {
    Owner      = "keyTsai"
    CostCenter = "free-tier"
  }

  budget_limit = 10
  budget_email = "keytsai14@gmail.com"
}
