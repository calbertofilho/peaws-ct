# Configure the terraform requirements
terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "~> 5.0"
        }
    }
    required_version = ">= 1.9.0"
}

# Configure the provider
provider "aws" {
    region = "us-east-1"
}
