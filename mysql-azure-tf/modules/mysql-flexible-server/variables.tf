variable "environment" {
  description = "Environment name (dev, stg, prod)"
  type        = string
}

variable "resource_group_name" {
  description = "Base name for the resource group"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "japaneast"
}

variable "server_name" {
  description = "Base name for the MySQL server"
  type        = string
}

variable "administrator_login" {
  description = "Admin username"
  type        = string
}

variable "administrator_password" {
  description = "Admin password"
  type        = string
  sensitive   = true
}

variable "sku_name" {
  description = "SKU name"
  type        = string
}

variable "size_gb" {
  description = "Storage size in GB"
  type        = number
  default       = 100
}

variable "mysql_version" {
  description = "MySQL version"
  type        = string
  default       = "5.7"
}

variable "zone" {
  description = "Availability zone"
  type        = string
  default       = "1"
}

variable "backup_retention_days" {
  description = "Backup retention days"
  type        = number
  default       = 7
}

variable "firewall_rules" {
  type = map(object({
    name             = string
    start_ip_address = string
    end_ip_address   = string
  }))
  default     = {}  # 重要：默认空map
  description = "防火墙规则定义（name/start_ip/end_ip）"
}

variable "public_network_access_enabled" {
  type        = bool
  default     = true
  description = "是否启用公网访问"
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}

variable "sql_mode" {
  description = "MySQL sql_mode configuration string"
  type        = string
  default     = "STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION"
}

variable "require_secure_transport" {
  description = "Whether to require secure transport (TLS)"
  type        = bool
  default     = true
}
