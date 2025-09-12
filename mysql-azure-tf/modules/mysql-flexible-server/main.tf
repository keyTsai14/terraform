resource "azurerm_mysql_flexible_server" "mysql" {
    name = var.server_name
    resource_group_name = var.resource_group_name
    location = var.location
    administrator_login = var.administrator_login
    administrator_password = var.administrator_password
    sku_name = var.sku_name
    storage {
      size_gb = var.size_gb  # 必须在 storage 块内定义
    }
    version = var.mysql_version
    zone = var.zone
    backup_retention_days = var.backup_retention_days
    # Note: azurerm v4+ determines public access automatically; do not set explicitly.


    # 禁用 SSL 强制 (对应 --ssl-enforcement Disabled)
    # ssl_enforcement_enabled       = var.ssl_enforcement_enabled

    tags = var.tags

    lifecycle {
        # 防止密码被意外修改
        ignore_changes = [
            administrator_password
        ]
    }

}

resource "azurerm_mysql_flexible_server_configuration" "disable_secure_transport" {
  name                = "require_secure_transport"
  resource_group_name = var.resource_group_name
  server_name         = azurerm_mysql_flexible_server.mysql.name
  value               = var.require_secure_transport ? "ON" : "OFF"
}

# 设置 sql_mode（例如严格模式）
resource "azurerm_mysql_flexible_server_configuration" "sql_mode" {
  name                = "sql_mode"
  resource_group_name = var.resource_group_name
  server_name         = azurerm_mysql_flexible_server.mysql.name
  value               = var.sql_mode
}

# 条件化创建防火墙规则
resource "azurerm_mysql_flexible_server_firewall_rule" "rules" {
  for_each = var.public_network_access_enabled ? var.firewall_rules : {}

  server_name         = azurerm_mysql_flexible_server.mysql.name
  resource_group_name = azurerm_mysql_flexible_server.mysql.resource_group_name
  name                = each.value.name
  start_ip_address    = each.value.start_ip_address
  end_ip_address      = each.value.end_ip_address
}
