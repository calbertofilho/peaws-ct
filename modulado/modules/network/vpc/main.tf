### VPC
resource "aws_vpc" "main" {
    cidr_block = var.vpc_cidr_block
    tags = {
        Name = "${var.vpc_name}-VPC"
    }
    tags = merge(local.common_tags, {
        Name = format("%s", local.vpc_name)
    })
    lifecycle {
        ignore_changes = [
            tags["Created_Date"]
        ]
    }
}

### INTERNET GATEWAY
resource "aws_internet_gateway" "gw" {
    vpc_id = aws_vpc.main.id
    tags = {
        Name = "${var.vpc_name}-IGW"
    }
}

### PUBLIC SUBNETS
resource "aws_subnet" "public_subnets" {
    count = length(var.azs)
    vpc_id = aws_vpc.main.id
    availability_zone = element(var.azs, count.index)
    cidr_block = element(var.public_subnet_cidrs, count.index)
    tags = {
        Name = "Public Subnet ${count.index + 1}"
    }
}

### PRIVATE SUBNETS
resource "aws_subnet" "private_subnets" {
    count = length(var.azs)
    vpc_id = aws_vpc.main.id
    availability_zone = element(var.azs, count.index)
    cidr_block = element(var.private_subnet_cidrs, count.index)
    tags = {
        Name = "Private Subnet ${count.index + 1}"
    }
}

### ELASTIC IP
resource "aws_eip" "elastic_ips" {
    count = length(aws_subnet.private_subnets)
    domain = "vpc"
}

### NAT GATEWAY
resource "aws_nat_gateway" "nat_gw" {
    count = length(aws_subnet.private_subnets)
    allocation_id = element(aws_eip.elastic_ips, count.index).id
    subnet_id = element(aws_subnet.private_subnets, count.index).id
}

### PUBLIC ROUTE TABLE
resource "aws_route_table" "public_subnets" {
    vpc_id = aws_vpc.main.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.gw.id
    }
    tags = {
        Name = "Public Subnet Route Table"
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
    count  = length(aws_nat_gateway.nat_gw)
    vpc_id = aws_vpc.main.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = element(aws_nat_gateway.nat_gw, count.index).id
    }
    tags = {
        Name = "Private Subnet Route Table"
    }
}

### PRIVATE ROUTE TABLE ASSOCIATION
resource "aws_route_table_association" "private_subnet_assoc" {
    count = length(aws_subnet.private_subnets)
    subnet_id = element(aws_subnet.private_subnets[*].id, count.index)
    route_table_id = element(aws_route_table.private_subnets[*].id, count.index)
}