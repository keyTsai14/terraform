variable "region" {
  type        = string
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

data "aws_caller_identity" "current" {}