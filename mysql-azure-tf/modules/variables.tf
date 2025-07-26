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

variable "storage_gb" {
  description = "Storage size in GB"
  type        = number
}

variable "version" {
  description = "MySQL version"
  type        = string
}

variable "zone" {
  description = "Availability zone"
  type        = string
}

variable "backup_retention_days" {
  description = "Backup retention days"
  type        = number
}

variable "database_name" {
  description = "Database name"
  type        = string
}