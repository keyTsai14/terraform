variable "budget_name" {
  description = "AWS Budget name"
  type        = string
}

variable "budget_limit" {
  description = "Monthly budget limit in USD"
  type        = number
}

variable "budget_email" {
  description = "Email to receive budget alerts"
  type        = string
}

variable "tags" {
  description = "Common tags"
  type        = map(string)
  default     = {}
}

