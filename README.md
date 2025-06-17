# terraform
## Install Terraform
```shell
# First, install the HashiCorp tap, a repository of all our Homebrew packages.
brew tap hashicorp/tap
# Now, install Terraform with hashicorp/tap/terraform.
brew install hashicorp/tap/terraform

# To update to the latest version of Terraform, first update Homebrew.
brew update

# Then, run the upgrade command to download and use the latest Terraform version.
brew upgrade hashicorp/tap/terraform
==> Upgrading 1 outdated package:
hashicorp/tap/terraform 0.15.3 -> 1.0.0
==> Upgrading hashicorp/tap/terraform 0.15.3 -> 1.0.0

# Verify the installation
terraform -help
```

## Quick start tutorial for docker

Download [Docker Desktop for Mac](https://docs.docker.com/docker-for-mac/install/).

After you install Terraform and Docker on your local machine, start Docker Desktop.
```shell
open -a Docker
```

Create a directory named `learn-terraform-docker-container`.
```shell
mkdir learn-terraform-docker-container
```

Navigate into the working directory.
```shell
cd learn-terraform-docker-container
```

Create a file named `main.tf` in the working directory.
```shell
touch main.tf
```
※ detail see [main.tf](./learn-terraform-docker-container/main.tf)

Initialize the project, which downloads a plugin called a provider that lets Terraform interact with Docker.
```shell
$ terraform init
```

Provision the NGINX server container with apply. When Terraform asks you to confirm type yes and press ENTER
```shell
$ terraform apply
```

Verify the existence of the NGINX container by visiting localhost:8000 in your web browser or running docker ps to see the container.
```shell
docker ps
```

Destroy the NGINX container with terraform destroy. When Terraform asks you to confirm type yes and press ENTER
```shell
$ terraform destroy
```

## Build infrastructure for aws building

To follow this tutorial you will need:
- The Terraform CLI (1.2.0+) installed.
- The AWS CLI installed.
- AWS account and associated credentials that allow you to create resources.

To use your IAM credentials to authenticate the Terraform AWS provider, set the AWS_ACCESS_KEY_ID environment variable.
```shell
export AWS_ACCESS_KEY_ID=YOUR_ACCESS_KEY
```

To use your IAM credentials to authenticate the Terraform AWS provider, set the AWS_SECRET_ACCESS_KEY environment variable.
```shell
export AWS_SECRET_ACCESS_KEY=YOUR_SECRET_KEY
```

```shell
# Each Terraform configuration must be in its own working directory. Create a directory for your configuration.
$ mkdir learn-terraform-aws-instance

# Change into the directory.
$ cd learn-terraform-aws-instance

# Create a file to define your infrastructure.
$ touch main.tf
```

※ detail see [main.tf](./learn-terraform-aws-instance/main.tf)

Format your configuration. Terraform will print out the names of the files it modified, if any. In this case, your configuration file was already formatted correctly, so Terraform won't return any file names.
```shell
$ terraform fmt
```

You can also make sure your configuration is syntactically valid and internally consistent by using the terraform validate command.
```shell
$ terraform validate
```

Initialize the project, which downloads a plugin called a provider that lets Terraform interact with AWS.
```shell
$ terraform init
```

Provision the EC2 instance with apply. When Terraform asks you to confirm type yes and press ENTER
```shell
$ terraform apply
```

Inspect the current state using terraform show.
```shell
$ terraform show
```

Terraform has a built-in command called terraform state for advanced state management. Use the list subcommand to list of the resources in your project's state.
```shell
$ terraform state list
aws_instance.app_server
```

Destroy the EC2 instance with terraform destroy. When Terraform asks you to confirm type yes and press ENTER
```shell
$ terraform destroy
```


## use local config file to build infrastructure for aws building

```shell
terraform init
terraform apply -var-file=../shared-configs/aws-creds.tfvars
terraform destroy -var-file=../shared-configs/aws-creds.tfvars
```