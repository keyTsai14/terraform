# 4. Output credentials (mark secret as sensitive)
output "access_key_id" {
  value = aws_iam_access_key.terraform_user_key.id
}

output "secret_access_key" {
  value     = aws_iam_access_key.terraform_user_key.secret
  sensitive = true
}