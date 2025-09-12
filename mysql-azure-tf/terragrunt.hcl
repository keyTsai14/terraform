# Root terragrunt configuration - shared configuration for all environments
locals {
  tfvars_file = "${get_parent_terragrunt_dir()}/common.tfvars"
  # Remote state defaults (can be overridden via env vars)
  state_rg         = get_env("TF_STATE_RG", "rg-tfstate-example")
  state_sa         = get_env("TF_STATE_SA", "sttfstateexample")
  state_container  = get_env("TF_STATE_CONTAINER", "tfstate")
  state_key_prefix = "mysql-azure-tf"
}

terraform {
  # No source at root; environments set their own module source.
  extra_arguments "common_tfvars" {
    commands  = ["plan", "apply"]
    arguments = ["-var-file=${local.tfvars_file}"]
  }
}

# Centralized remote state for all environments (Azure Storage)
remote_state {
  backend = "azurerm"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite"
  }
  config = {
    resource_group_name  = local.state_rg
    storage_account_name = local.state_sa
    container_name       = local.state_container
    key                  = "${local.state_key_prefix}/${path_relative_to_include()}/terraform.tfstate"
    use_azuread_auth     = true
  }
}
