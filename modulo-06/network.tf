# Criação da VPC (vpc)
resource "aws_vpc" "project-vpc" {
    cidr_block = "10.0.0.0/16"
    enable_dns_hostnames = true

    tags = merge(local.common_tags, {
        Name = local.vpc_name
    })

    lifecycle {
        ignore_changes = [
            tags["Created_Date"]
        ]
    }
}

# Criação da Subnet Pública (public_subnet)
resource "aws_subnet" "tcb_blog_public_subnet" {
    vpc_id     = aws_vpc.project-vpc.id
    cidr_block = "10.0.1.0/24"

    tags = merge(local.common_tags, {
        Name = "tcb_blog_public_subnet"
    })

    lifecycle {
        ignore_changes = [
            tags["Created_Date"]
        ]
    }
}

# Criação do Internet Gateway (igw)
resource "aws_internet_gateway" "tcb_blog_igw" {
    vpc_id = aws_vpc.project-vpc.id

    tags = merge(local.common_tags, {
        Name = "tcb_blog_igw"
    })

    lifecycle {
        ignore_changes = [
            tags["Created_Date"]
        ]
    }
}

# Criação da Tabela de Roteamento (rtb)
resource "aws_route_table" "tcb_blog_rt" {
    vpc_id = aws_vpc.project-vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.tcb_blog_igw.id
    }

    tags = merge(local.common_tags, {
        Name = "tcb_blog_rt"
    })

    lifecycle {
        ignore_changes = [
            tags["Created_Date"]
        ]
    }
}

# Criação da Rota Default para Acesso à Internet
resource "aws_route" "tcb_blog_routetointernet" {
    route_table_id            = aws_route_table.tcb_blog_rt.id
    destination_cidr_block    = "0.0.0.0/0"
    gateway_id                = aws_internet_gateway.tcb_blog_igw.id
}

# Associação da Subnet Pública com a Tabela de Roteamento
resource "aws_route_table_association" "tcb_blog_pub_association" {
    subnet_id      = aws_subnet.tcb_blog_public_subnet.id
    route_table_id = aws_route_table.tcb_blog_rt.id
}
