output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.example.id
}

output "ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.example.id
}

output "aws_s3_bucket" {
  description = "S3 Bucket name"
  value       = aws_s3_bucket.example.id
}
