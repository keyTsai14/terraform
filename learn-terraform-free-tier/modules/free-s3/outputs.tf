output "bucket_id" {
  value       = aws_s3_bucket.this.id
  description = "The S3 bucket ID"
}

output "bucket_arn" {
  value       = aws_s3_bucket.this.arn
  description = "The S3 bucket ARN"
}

