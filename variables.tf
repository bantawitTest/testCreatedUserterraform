variable "user_name" {
  description = "The name of the IAM user"
  type        = string
}

variable "role_name" {
  description = "The IAM role name to be associated"
  type        = string
  default     = "AccountAutomationPro"
}

variable "account_id" {
  description = "The AWS account ID"
  type        = string
}

variable "ip_addresses" {
  description = "The list of IP addresses for permissions boundary"
  type        = string
}
