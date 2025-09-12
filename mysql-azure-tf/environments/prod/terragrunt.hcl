include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../modules/mysql-flexible-server"
}

inputs = {
  environment           = "prod"
  resource_group_name   = "mysql-rg"
  location              = "eastus"
  server_name           = "mysql-server"
  administrator_login   = "prodadmin"
  sku_name              = "B_Standard_B1ms"
  size_gb               = 100
  mysql_version         = "8.0.21"
  zone                  = "1"
  backup_retention_days = 7
  # database_name is not used by module; removed to avoid unknown variable

}
