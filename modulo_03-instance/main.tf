# Configure the terraform requirements
terraform {
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

# Define resources names and default tags
locals {
    my_public_ip_address = format("%s/%s", data.external.myipaddr.result["ip"], 32)
    vpc_name = format("%s-%s-vpc", var.project_customer, var.project_name)
    subnet_name = format("%s-%s-net", var.project_customer, var.project_name)
    gateway_name = format("%s-%s-igw", var.project_customer, var.project_name)
    route_name = format("%s-%s-rtb", var.project_customer, var.project_name)
    acl_name = format("%s-%s-acl", var.project_customer, var.project_name)
    sg_name = format("%s-%s-sg", var.project_customer, var.project_name)
    instance_name = format("%s-%s-ec2", var.project_customer, var.project_name)
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
