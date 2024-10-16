### INTERNET GATEWAY ###
# Criação do Internet Gateway (igw)
resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.vpc.id
    tags = merge(local.common_tags, {
        Name = format("%s", local.gateway_name)
    })
}

### ROUTE TABLE ###
# Criação da Route Table Pública (public_rtb)
resource "aws_route_table" "public_rtb" {
    vpc_id = aws_vpc.vpc.id
    tags = merge(local.common_tags, {
        Name = format("%s-public", local.route_name)
    })
    route {
        cidr_block = format("%s", var.project_cidr-blocks["all"][0])
        gateway_id = aws_internet_gateway.igw.id
    }
}

# Criação da Route Table Privada (private_rtb)
resource "aws_route_table" "private_rtb" {
    vpc_id = aws_vpc.vpc.id
    tags = merge(local.common_tags, {
        Name = format("%s-private", local.route_name)
    })
}

# Associação da Tabela de Roteamento Privada como padrão para a VPC criada (main_rtb)
resource "aws_main_route_table_association" "main_rtb" {
    vpc_id = aws_vpc.vpc.id
    route_table_id = aws_route_table.private_rtb.id
}

# Associação da Subnet Pública com a Tabela de Roteamento Pública (public_rtb_assoc)
resource "aws_route_table_association" "public_rtb_assoc" {
    count = length(aws_subnet.public_subnet)
    subnet_id = aws_subnet.public_subnet[count.index].id
    route_table_id = aws_route_table.public_rtb.id
}

# Associação da Subnet Privada com a Tabela de Roteamento Privada (private_rtb_assoc)
resource "aws_route_table_association" "private_rtb_assoc" {
    count = length(aws_subnet.private_subnet)
    subnet_id = aws_subnet.private_subnet[count.index].id
    route_table_id = aws_route_table.private_rtb.id
}