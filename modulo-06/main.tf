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

# Define resources names and default tags
locals {
    vpc_name = format("%s-%s-vpc_%s", var.project_customer, var.project_name, var.project_provider)
    ec2_name = format("%s-%s-ec2_%s", var.project_customer, var.project_name, var.project_provider)
    rds_name = format("%s-%s-rds_%s", var.project_customer, var.project_name, var.project_provider)
    common_tags = {
        Environment = "Test"
        Project = var.project_name
        Customer = var.project_customer
        Created_Date = formatdate("YYYY-MM-DD hh:mm:ss ZZZ", timestamp())
        Modified_Date = formatdate("YYYY-MM-DD hh:mm:ss ZZZ", timestamp())
        Created_By = "Terraform"
    }
}
