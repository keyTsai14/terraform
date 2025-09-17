locals {
  environment = "dev"
  aws_region  = "us-east-1"

  # 多账号：使用本机 AWS profile
  aws_profile = "dev"

  tags = {
    Owner      = "keyTsai"
    CostCenter = "free-tier"
  }

  # Global budget settings (used by _globals/budget)
  budget_limit = 5
  budget_email = "keytsai14@gmail.com"
}
