variable "bucket_name" {
  description = "S3 bucket name"
  type        = string
}

variable "tags" {
  description = "Common resource tags"
  type        = map(string)
  default     = {}
}


variable "prevent_destroy" {
  description = "Prevent accidental bucket destroy"
  type        = bool
  default     = false
}
