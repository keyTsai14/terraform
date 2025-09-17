output "budget_id" {
  description = "Budget resource name"
  value       = aws_budgets_budget.monthly.name
}

output "sns_topic_arn" {
  description = "SNS topic for budget alerts"
  value       = aws_sns_topic.budget.arn
}

