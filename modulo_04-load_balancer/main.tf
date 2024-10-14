terraform {
    backend "local" {
        path = ".terraform/terraform.tfstate"
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