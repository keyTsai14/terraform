variable "region" {
  default     = "ap-northeast-1"
  description = "AWS Region"
}

variable "aws_access_key" {
  type        = string
  description = "AWS Access Key"
}

variable "aws_secret_key" {
  type        = string
  description = "AWS Secret Key"
}

variable "db_password" {
  description = "Database Password"
  sensitive   = true
}

variable "db_name" {
  description = "The name of the database"
  type        = string
}

variable "my_ip_cidr" {
  description = "My IP CIDR"
}