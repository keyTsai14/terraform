terraform {
  # keep this file as the single include root
}

locals {
  # 读取环境配置（可选），用于统一区域与标签
  env_config  = try(read_terragrunt_config(find_in_parent_folders("env.hcl")), {})
  environment = try(local.env_config.locals.environment, "global")
  aws_region  = try(local.env_config.locals.aws_region, "us-east-1")
  common_tags = merge(
    {
      Project     = "learn-terraform-free-tier"
      Environment = local.environment
      ManagedBy   = "terragrunt"
    },
    try(local.env_config.locals.tags, {})
  )

  # 从 env.hcl 读取账号切换参数（仅使用 aws_profile）
  selected_profile = try(local.env_config.locals.aws_profile, null)
}

# 让 Terragrunt 自身按所选账号执行（影响 get_aws_account_id、remote_state、module 执行）

# 远程状态配置 - 使用S3存储Terraform状态
remote_state {
  backend = "s3"
  config = {
    bucket         = "free-tier-tfstate-${get_aws_account_id()}"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = local.aws_region
    encrypt        = true
    dynamodb_table = "terraform-lock-${get_aws_account_id()}"
  }
}

# 向每个模块注入 provider 与通用输入
inputs = {
  aws_region    = local.aws_region
  tags          = local.common_tags
  provider_tags = local.common_tags
}

# 自动生成 provider 配置，避免每个模块重复
generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<-EOF
    terraform {
      required_version = ">= 1.5.0"
      required_providers {
        aws = {
          source  = "hashicorp/aws"
          version = "~> 6.0"
        }
      }
    }

    variable "aws_region" {
      type    = string
      default = "us-east-1"
    }

    variable "provider_tags" {
      type    = map(string)
      default = {}
    }

    provider "aws" {
      region = var.aws_region
      default_tags {
        tags = var.provider_tags
      }
    }
  EOF
}
