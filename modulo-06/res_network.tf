# Criação da VPC (vpc)
resource "aws_vpc" "vpc" {
    cidr_block = var.project_cidr
    enable_dns_hostnames = true
    enable_dns_support = true

    tags = merge(local.common_tags, {
    # tags = {
        Name = "${local.vpc_name}"
    # }
    })

    lifecycle {
        ignore_changes = [
            tags["Created_Date"]
        ]
    }
}

# Consulta das zonas disponiveis na regiao selecionada
data "aws_availability_zones" "available_zones" {
    state = "available"
    filter {
        name = "region-name"
        values = [var.project_region]
    }
}

# Criação das Subnets Privadas (private_subnet)
resource "aws_subnet" "private_subnet" {
    count = length(data.aws_availability_zones.available_zones.names)
    vpc_id = aws_vpc.vpc.id
    # cidr_block = cidrsubnet(cidrsubnet(aws_vpc.vpc.cidr_block, 2, 2), 8, count.index)
    cidr_block = cidrsubnet(aws_vpc.vpc.cidr_block, 8, count.index+10)
    availability_zone = data.aws_availability_zones.available_zones.names[count.index]
    tags = merge(local.common_tags, {
    # tags = {
        Name = "${local.subnet_name}-private${count.index+1}"
    # }
    })

    lifecycle {
        ignore_changes = [
            tags["Created_Date"]
        ]
    }
}

# Criação das Subnets Públicas (public_subnet)
resource "aws_subnet" "public_subnet" {
    count = length(data.aws_availability_zones.available_zones.names)
    vpc_id = aws_vpc.vpc.id
    cidr_block = cidrsubnet(aws_vpc.vpc.cidr_block, 8, count.index+20)
    availability_zone = data.aws_availability_zones.available_zones.names[count.index]
    map_public_ip_on_launch = true
    tags = merge(local.common_tags, {
    # tags = {
        Name = "${local.subnet_name}-public${count.index+1}"
    # }
    })

    lifecycle {
        ignore_changes = [
            tags["Created_Date"]
        ]
    }
}

# Criação do Internet Gateway (igw)
resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.vpc.id
    tags = merge(local.common_tags, {
    # tags = {
        Name = "${local.gateway_name}"
    # }
    })
}

# Criação da Route Table Pública (rtb)
resource "aws_route_table" "public_rtb" {
    vpc_id = aws_vpc.vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }

    tags = merge(local.common_tags, {
    # tags = {
        Name = "${local.route_name}-public"
    # }
    })
}

# Criação da Route Table Privada (rtb)
resource "aws_route_table" "private_rtb" {
    vpc_id = aws_vpc.vpc.id
    tags = merge(local.common_tags, {
    # tags = {
        Name = "${local.route_name}-private"
    # }
    })
}

# Associação da Subnet Pública com a Tabela de Roteamento Pública
resource "aws_route_table_association" "public_rtb_assoc" {
    count = length(aws_subnet.public_subnet)
    subnet_id = aws_subnet.public_subnet[count.index].id
    route_table_id = aws_route_table.public_rtb.id
}

# Associação da Subnet Pública com a Tabela de Roteamento Privada
resource "aws_route_table_association" "private_rtb_assoc" {
    count = length(aws_subnet.private_subnet)
    subnet_id = aws_subnet.private_subnet[count.index].id
    route_table_id = aws_route_table.private_rtb.id
}
