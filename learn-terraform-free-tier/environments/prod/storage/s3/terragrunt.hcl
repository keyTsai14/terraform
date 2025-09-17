include "root" {
  path = find_in_parent_folders()
}

locals {
  env = read_terragrunt_config(find_in_parent_folders("env.hcl"))
}

terraform {
  source = "../../../../modules/free-s3"
}

inputs = {
  bucket_name = "free-${local.env.locals.environment}-${get_aws_account_id()}-${local.env.locals.aws_region}"
}

