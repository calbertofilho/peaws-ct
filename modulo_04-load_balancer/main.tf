terraform {
    backend "local" {
        path = ".tfstate/terraform.tfstate"
        workspace_dir = ".tfstate"
    }
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "~> 5.0"
        }
        external = {
            source = "hashicorp/external"
            version = "~> 2.0"
        }
    }
    required_version = ">= 1.2.0"
}