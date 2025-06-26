resource "aws_apprunner_service" "demo-app" {
    name = "demo-app"
    source_configuration {
        image_repository {
            image_identifier = "${data.aws_caller_identity.current.account_id}.dkr.ecr.${var.region}.amazonaws.com/demo-app:latest"
            image_repository_type = "ECR"
            image_configuration {
                port = "8080"
            }
        }
    }
    auto_deployments_enabled = true
    
}