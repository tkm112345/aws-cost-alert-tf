# =============================================================================
# Outputs for AWS Cost Alert Resources
# =============================================================================

# SNS Topic Outputs
output "sns_topic_arn" {
  description = "ARN of the created SNS topic"
  value       = aws_sns_topic.cost_alert.arn
}

output "sns_topic_name" {
  description = "Name of the created SNS topic"
  value       = aws_sns_topic.cost_alert.name
}

# SNS Subscription Outputs
output "subscription_arn" {
  description = "ARN of email subscription"
  value       = aws_sns_topic_subscription.email_alert.arn
}

# Budget Outputs
output "budget_name" {
  description = "Name of the created budget"
  value       = aws_budgets_budget.monthly_cost_budget.name
}

# Additional useful outputs for production monitoring
output "aws_account_id" {
  description = "AWS Account ID where resources are created"
  value       = data.aws_caller_identity.current.account_id
}

output "aws_region" {
  description = "AWS region where resources are deployed"
  value       = "ap-northeast-1"
}