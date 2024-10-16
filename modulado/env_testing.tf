module "vpc" {
    source = "./modules/network/vpc"
    vpc_name = format("%s-bug-test", data.aws_caller_identity.current.id)
    azs = [data.aws_availability_zones.available_zones.names[0], data.aws_availability_zones.available_zones.names[1]]
    vpc_cidr_block = format("%s", var.project_cidr-blocks["vpc"][0])
    private_subnet_cidrs = ["10.0.11.0/24", "10.0.12.0/24"]
    public_subnet_cidrs = ["10.0.21.0/24", "10.0.22.0/24"]
#    enable_dns_hostnames = true
#    enable_dns_support = true
#    enable_nat_gateway = true
#    single_nat_gateway = true
#    one_nat_gateway_per_az = false
#    enable_vpn_gateway = false
}