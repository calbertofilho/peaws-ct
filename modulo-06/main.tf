# Configure the terraform requirements
terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "~> 5.0"
        }
    }
    required_version = ">= 1.2.0"
}

# Define resources names
locals {
    vpc_name = format("%s-%s-%s-vpc", var.project_provider, var.project_customer, var.project_name)
    ec2_name = format("%s-%s-%s-ec2", var.project_provider, var.project_customer, var.project_name)
    rds_name = format("%s-%s-%s-rds", var.project_provider, var.project_customer, var.project_name)
}
