include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../modules/mysql-flexible-server"
}

inputs = {
  environment           = "dev"
  resource_group_name   = "yourproject-dev-other-RG"
  location              = "japaneast"
  server_name           = "yourproject-dev-mysql-server"
  administrator_login   = "mysqluser"
  sku_name              = "B_Standard_B2s"
  size_gb               = 100
  mysql_version         = "5.7"
  backup_retention_days = 7
  sql_mode              = "STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION"
}

# Override remote state for dev to use local backend for quick testing
remote_state {
  backend = "local"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite"
  }
  config = {
    path = "./terraform.tfstate"
  }
}
