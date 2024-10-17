### VPC
resource "aws_vpc" "main" {
    cidr_block = var.vpc_cidr_block
    enable_dns_hostnames = var.enable_dns_hostnames
    enable_dns_support = var.enable_dns_support
    tags = merge(var.common_tags, {
        Name = "${var.vpc_name}.VPC"
    })
    lifecycle {
        ignore_changes = [
            tags["Created_Date"]
        ]
    }
}

### PUBLIC SUBNETS
resource "aws_subnet" "public_subnets" {
    count = var.total_azs_to_create
    vpc_id = aws_vpc.main.id
    availability_zone = element(var.azs, count.index)
    cidr_block = element([cidrsubnet(var.vpc_cidr_block, 8, count.index+20)], count.index)
    tags = merge(var.common_tags, {
        Name = "${var.vpc_name}.PubSubNet${count.index+1}"
    })
    lifecycle {
        ignore_changes = [
            tags["Created_Date"]
        ]
    }
}

### PRIVATE SUBNETS
resource "aws_subnet" "private_subnets" {
    count = var.total_azs_to_create
    vpc_id = aws_vpc.main.id
    availability_zone = element(var.azs, count.index)
    cidr_block = element([cidrsubnet(var.vpc_cidr_block, 8, count.index+10)], count.index)
    tags = merge(var.common_tags, {
        Name = "${var.vpc_name}.PrvSubNet${count.index+1}"
    })
    lifecycle {
        ignore_changes = [
            tags["Created_Date"]
        ]
    }
}

### INTERNET GATEWAY
resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.main.id
    tags = merge(var.common_tags, {
        Name = "${var.vpc_name}.IGW"
    })
    lifecycle {
        ignore_changes = [
            tags["Created_Date"]
        ]
    }
}

### ELASTIC IP
# resource "aws_eip" "elastic_ips" {
#     count = length(aws_subnet.private_subnets)
#     domain = "vpc"
#     tags = merge(var.common_tags, {
#         Name = "${var.vpc_name}.ElasticIP${count.index+1}"
#     })
#     lifecycle {
#         ignore_changes = [
#             tags["Created_Date"]
#         ]
#     }
# }

### NAT GATEWAY
# resource "aws_nat_gateway" "nat_gw" {
#     count = length(aws_subnet.private_subnets)
#     allocation_id = element(aws_eip.elastic_ips, count.index).id
#     subnet_id = element(aws_subnet.private_subnets, count.index).id
#     tags = merge(var.common_tags, {
#         Name = "${var.vpc_name}.NatGW${count.index+1}"
#     })
#     lifecycle {
#         ignore_changes = [
#             tags["Created_Date"]
#         ]
#     }
# }

### PUBLIC ROUTE TABLE
resource "aws_route_table" "public_subnets" {
    vpc_id = aws_vpc.main.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }
    tags = merge(var.common_tags, {
        Name = "${var.vpc_name}.PubRTB"
    })
    lifecycle {
        ignore_changes = [
            tags["Created_Date"]
        ]
    }
}

### PUBLIC ROUTE TABLE ASSOCIATION
resource "aws_route_table_association" "public_subnet_assoc" {
    count = length(aws_subnet.public_subnets)
    subnet_id = element(aws_subnet.public_subnets[*].id, count.index)
    route_table_id = aws_route_table.public_subnets.id
}

## PRIVATE ROUTE TABLE
resource "aws_route_table" "private_subnets" {
    # count  = length(aws_nat_gateway.nat_gw)
    vpc_id = aws_vpc.main.id
    # route {
    #     cidr_block = "0.0.0.0/0"
    #     gateway_id = element(aws_nat_gateway.nat_gw, count.index).id
    # }
    tags = merge(var.common_tags, {
        Name = "${var.vpc_name}.PrvRTB"
    })
    lifecycle {
        ignore_changes = [
            tags["Created_Date"]
        ]
    }
}

### PRIVATE ROUTE TABLE ASSOCIATION
resource "aws_route_table_association" "private_subnet_assoc" {
    count = length(aws_subnet.private_subnets)
    subnet_id = element(aws_subnet.private_subnets[*].id, count.index)
    # route_table_id = element(aws_route_table.private_subnets[*].id, count.index)
    route_table_id = aws_route_table.private_subnets.id
}