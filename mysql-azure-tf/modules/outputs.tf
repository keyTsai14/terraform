output "mysql_server_name" {
  value = azurerm_mysql_flexible_server.mysql.name
}

# ​​FQDN​​：完全限定域名，用于连接数据库
output "mysql_server_fqdn" {
  value = azurerm_mysql_flexible_server.mysql.fqdn
}

output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}