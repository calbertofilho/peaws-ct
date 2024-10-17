module "vpc" {
    source = "./modules/network/vpc"
    vpc_name = local.name
    vpc_cidr_block = var.project_cidr-blocks["vpc"]
    azs = data.aws_availability_zones.available_zones.names
    total_azs_to_create = 2   # length(data.aws_availability_zones.available_zones.names)
    enable_dns_hostnames = true
    enable_dns_support = true
    # enable_nat_gateway = true
    # single_nat_gateway = true
    # one_nat_gateway_per_az = false
    # enable_elastic_ip = true
    common_tags = local.common_tags
}