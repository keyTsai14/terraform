include "root" {
  path = find_in_parent_folders()
}

# 重要：Bootstrap 阶段使用本地 state，避免鸡生蛋蛋生鸡
remote_state {
  backend = "local"
  config = {
    path = ".terraform/terraform.tfstate"
  }
}

terraform {
  source = "../../modules/state-backend"
}


generate "backend" {
  path      = "backend.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<-EOF
    terraform {
      backend "local" {}
    }
  EOF
}
inputs = {
  bucket_name         = "free-tier-tfstate-${get_aws_account_id()}"
  dynamodb_table_name = "terraform-lock-${get_aws_account_id()}"
}

