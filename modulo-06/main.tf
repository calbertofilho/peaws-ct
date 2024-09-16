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
    region = var.project_region
}

# Set resources names
locals {
  rds_instance_name = format("%s-%s-%s-rds", var.project_provider, var.project_customer, var.project_name)
}
