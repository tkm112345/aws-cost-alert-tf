variable "email_address" {
  description = "Email address for alert notifications"
  type        = string
  default     = "your-actual-email@example.com"
}

variable "budget_amount_1" {
  description = "Monthly budget limit (USD) for first budget"
  type        = string
  default     = "8.00"
}

variable "budget_amount_2" {
  description = "Monthly budget limit (USD) for second budget"
  type        = string
  default     = "20.00"
}

variable "project_name" {
  description = "Watch AWS Cost"
  type        = string
  default     = "aws-cost-watch"
}

variable "environment" {
  description = "Environment name (dev, staging, prod, personal, etc.)"
  type        = string
  default     = "personal"
}

variable "sns_topic_name" {
  description = "SNS topic name"
  type        = string
  default     = "cost-alert-topic"
}