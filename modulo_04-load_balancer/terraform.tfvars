# All variables as it would be defined in the .tfvars file.

project_name = "modulo_04"
project_customer = "cloud_treinamentos"
project_provider = "aws"
project_region = "us-east-1"
#project_accessKey
#project_secretKey
project_cidr-blocks = {
    "all" = ["0.0.0.0/0"]
    "vpc" = ["10.0.0.0/16"]
    "ec2-connect" = ["18.206.107.24/29"]
}