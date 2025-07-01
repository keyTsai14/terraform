provider "aws" {
  region = "us-east-1" # Budgets are only available in us-east-1
}

# SNS Topic
resource "aws_sns_topic" "budget_alert_topic" {
  name = "budget-alert-topic"
}

# Email Subscription
resource "aws_sns_topic_subscription" "email_sub" {
  topic_arn = aws_sns_topic.budget_alert_topic.arn
  protocol  = "email"
  endpoint  = var.alert_email # Email address to send alerts to
}

# Budget
resource "aws_budgets_budget" "monthly_budget" {
  name         = "monthly-budget"
  budget_type  = "COST"
  limit_amount = "0.01"
  limit_unit   = "USD"
  time_unit    = "MONTHLY"

  cost_filter {
    name   = "Service"
    values = ["Amazon Elastic Compute Cloud - Compute"]
  }

  notification {
    comparison_operator        = "GREATER_THAN"
    notification_type          = "ACTUAL"
    threshold                  = 80
    threshold_type             = "PERCENTAGE"
    subscriber_email_addresses = [var.alert_email]
    subscriber_sns_topic_arns  = [aws_sns_topic.budget_alert_topic.arn]
  }
}