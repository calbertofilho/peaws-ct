# Module that sets the default values ​​of all project variables

project_name = "modulo_6"
project_customer = "cloud_treinamentos"
project_provider = "aws"
project_region = "us-east-1"
project_cidr-blocks = {
    "all"     = ["0.0.0.0/0"],
    "vpc"     = ["10.0.0.0/16"],
    "clients" = ["x.x.x.x/32", "x.x.x.x/32", "x.x.x.x/30"],
}
