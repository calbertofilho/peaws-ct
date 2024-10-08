# Module that sets the default values ​​of all project variables

project_name = "modulo-10"
project_customer = "cloud-treinamentos"
project_provider = "aws"
project_region = "us-east-1"
project_cidr-blocks = {
    "all" = ["0.0.0.0/0"],
    "vpc" = ["10.0.0.0/16"],
    "ec2-connect" = ["18.206.107.24/29"]
}
