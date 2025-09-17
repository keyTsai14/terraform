include "root" {
  path = find_in_parent_folders()
}

locals {
  # 从当前环境目录向上查找 env.hcl，确保使用 prod 环境参数
  env = try(read_terragrunt_config(find_in_parent_folders("env.hcl")), {})
}

terraform {
  source = "../../../../modules/budget-monitor"
}

inputs = {
  budget_name  = "free-tier-monthly-budget"
  budget_limit = try(local.env.locals.budget_limit, 10)
  budget_email = try(local.env.locals.budget_email, "changeme@example.com")
}
