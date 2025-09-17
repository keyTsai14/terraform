output "bucket_id" {
  description = "State bucket ID"
  value       = aws_s3_bucket.state.id
}

output "dynamodb_table_name" {
  description = "Lock table name"
  value       = aws_dynamodb_table.lock.name
}

