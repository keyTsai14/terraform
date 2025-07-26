resource "azurerm_resource_group" "rg" {
    name = "${var.environment}-${var.resource_group_name}"
    location = var.location
}

resource "azurerm_mysql_flexible_server" "mysql" {
    name = "${var.environment}-${var.mysql_server_name}"
    resource_group_name = azurerm_resource_group.rg.name
    location = azurerm_resource_group.rg.location
    administrator_login = var.administrator_login
    administrator_password = var.administrator_password
    sku_name = var.sku_name
    storage_gb = var.storage_gb
    version = var.version
    zone = var.zone
    backup_retention_days = var.backup_retention_days

    lifecycle {
        # 防止密码被意外修改
        ignore_changes = [
            administrator_password
        ]
    }

}

resource "azurerm_mysql_flexible_database" "mysql" {
  name                = var.database_name
  resource_group_name = azurerm_resource_group.rg.name
  server_name         = azurerm_mysql_flexible_server.mysql.name
  charset             = "utf8"
  collation           = "utf8_unicode_ci"
}