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

## Quick start tutorial

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