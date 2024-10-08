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
    bucket_name = format("%s.%s.%s.bucket", data.aws_caller_identity.current.account_id, var.project_customer, var.project_name)
    common_tags = {
        Environment = "Test"
        Project = var.project_name
        Customer = var.project_customer
        Created_Date = formatdate("YYYY-MM-DD hh:mm:ss ZZZ", timestamp())
        Modified_Date = formatdate("YYYY-MM-DD hh:mm:ss ZZZ", timestamp())
        Created_By = "Terraform"
        Developer = "Carlos Alberto Filho"
    }
}
