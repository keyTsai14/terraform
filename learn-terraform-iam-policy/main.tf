# Create an IAM user
resource "aws_iam_user" "aws-command" {
  name = "aws-command"
}

# Create the IAM policy for ECR push/pull
resource "aws_iam_policy" "demoappEcrAdminPolicy" {
  name        = "demoappEcrAdminPolicy"
  description = "Policy for ECR push/pull"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid    = "VisualEditor0",
        Effect = "Allow",
        Action = [
          "ecr:GetRegistryPolicy",
          "ecr:CreateRepository",
          "ecr:DescribeRepository",
          "ecr:DescribePullThroughCacheRules",
          "ecr:GetAuthorizationToken",
          "ecr:PutRegistryScanningConfiguration",
          "ecr:CreatePullThroughCacheRule",
          "ecr:DeletePullThroughCacheRule",
          "ecr:PutRegistryPolicy",
          "ecr:GetRegistryScanningConfiguration",
          "ecr:BatchImportUpstreamImage",
          "ecr:DeleteRegistryPolicy",
          "ecr:PutReplicationConfiguration"
        ],
        Resource = "*"
      },
      {
        Sid      = "VisualEditor1",
        Effect   = "Allow",
        Action   = "ecr:*",
        Resource = "arn:aws:ecr:${var.region}:${data.aws_caller_identity.current.account_id}:repository/terraform-app"
      }
    ]
  })
}


# Attach the policy to the IAM user
resource "aws_iam_user_policy_attachment" "aws-command_attach" {
  user       = aws_iam_user.aws-command.name
  policy_arn = aws_iam_policy.demoappEcrAdminPolicy.arn
}

# Create access key for the user
resource "aws_iam_access_key" "terraform_user_key" {
  user = aws_iam_user.aws-command.name
}