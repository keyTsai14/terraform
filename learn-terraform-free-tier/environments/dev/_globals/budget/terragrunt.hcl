include "root" {
  path = find_in_parent_folders()
}

locals {
  # 从当前环境目录向上查找 env.hcl，确保使用 dev 环境参数
  env = try(read_terragrunt_config(find_in_parent_folders("env.hcl")), {})
}

terraform {
  source = "../../../../modules/budget-monitor"
}

generate "backend" {
  path      = "backend.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<-EOF
    terraform {
      backend "s3" {}
    }
  EOF
}

inputs = {
  budget_name  = "free-tier-monthly-budget"
  budget_limit = try(local.env.locals.budget_limit, 10)
  budget_email = try(local.env.locals.budget_email, "changeme@example.com")
}
