variable "bucket_name" {
  description = "Name of the S3 bucket to store Terraform remote state"
  type        = string
}

variable "dynamodb_table_name" {
  description = "Name of the DynamoDB table for state locking"
  type        = string
}

variable "force_destroy" {
  description = "Allow force destroy of the state bucket"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Common tags"
  type        = map(string)
  default     = {}
}


variable "prevent_destroy" {
  description = "Prevent accidental bucket destroy"
  type        = bool
  default     = false
}
