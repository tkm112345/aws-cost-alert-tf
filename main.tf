terraform {
  required_version = ">= 1.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region  = "ap-northeast-1"
  profile = "dev"

  default_tags {
    tags = {
      Environment = var.environment
      ManagedBy   = "Terraform"
      Project     = "CostAlert"
    }
  }
}

# =============================================================================
# Data Sources
# =============================================================================

data "aws_caller_identity" "current" {}

# =============================================================================
# SNS Topic for Budget Alerts
# =============================================================================

# First resource: SNS Topic
resource "aws_sns_topic" "cost_alert" {
  name         = var.sns_topic_name
  display_name = "AWS Cost Alert Notification"

  tags = {
    Environment = var.environment
    CreatedBy   = "Terraform"
  }
}

# SNS Topic Subscription for Email Alerts
resource "aws_sns_topic_subscription" "email_alert" {
  topic_arn = aws_sns_topic.cost_alert.arn
  protocol  = "email"
  endpoint  = var.email_address
}

# =============================================================================
# Budget Configuration
# =============================================================================

resource "aws_budgets_budget" "monthly_cost_budget" {
  name         = "${var.project_name}-monthly-budget"
  budget_type  = "COST"
  limit_amount = var.budget_amount
  limit_unit   = "USD"
  time_unit    = "MONTHLY"


  # Alert when forecast exceeds 80% of budget
  notification {
      comparison_operator = "GREATER_THAN"
      threshold = 80
      threshold_type = "PERCENTAGE"
      notification_type = "FORECASTED"
      subscriber_sns_topic_arns = [aws_sns_topic.cost_alert.arn]
  }

  # Alert when forecast exceeds 100% of budget
  notification {
      comparison_operator = "GREATER_THAN"
      threshold = 100
      threshold_type = "PERCENTAGE"
      notification_type = "ACTUAL"
      subscriber_sns_topic_arns = [aws_sns_topic.cost_alert.arn]
  }
}