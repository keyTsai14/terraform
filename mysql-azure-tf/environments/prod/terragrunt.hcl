include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../modules/mysql-flexible-server"
}

inputs = {
    environment            = "prod"
    resource_group_name    = "mysql-rg"
    location               = "eastus"
    server_name            = "mysql-server"
    administrator_login    = "prodadmin"
    administrator_password = "prodP@ss123!" # 实际使用中建议使用Azure Key Vault
    sku_name               = "B_Standard_B1ms"
    storage_gb             = 100
    version                = "8.0.21"
    zone                   = "1"
    backup_retention_days  = 7
    database_name          = "proddb"
    
}