# 当运行 terragrunt plan 或 terragrunt apply 时，
# 会自动加载项目根目录下的 common.tfvars 文件，使得所有环境都能共享一些基础配置。
terraform {
    # extra_arguments：所有 Terraform 命令添加额外的命令行参数
    extra_arguments "common_vars" {
        commands = get_terraform_commands_that_need_vars()          # 获取所有需要变量的 Terraform 命令
        arguments = [
            "-var-file=${get_terragrunt_dir()}/../common.tfvars"    # 相对于当前 terragrunt.hcl 文件的 ../common.tfvars 路径
        ]

    }
}



remote_state {
    backend = "azurerm"
    config = {
        resource_group_name = "terraform-rg"
        storage_account_name = "terraformsa"
        container_name = "terraform"
        key = "${path_relative_to_include()}/terraform.tfstate" # 获取相对于包含文件的路径
    }
}