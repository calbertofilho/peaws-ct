### VPC ###
# Criação da VPC (vpc)
resource "aws_vpc" "vpc" {
    cidr_block = format("%s", var.project_cidr-blocks["vpc"][0])
    enable_dns_hostnames = true
    enable_dns_support = true
    tags = merge(var.project_common_tags, {
        Name = format("%s", local.vpc_name)
    })
    lifecycle {
        ignore_changes = [
            tags["Created_Date"]
        ]
    }
}

### SUBNETS ###
# Criação das Subnets Privadas (private_subnet)
resource "aws_subnet" "private_subnet" {
    count = length(data.aws_availability_zones.available_zones.names)
    vpc_id = aws_vpc.vpc.id
    # cidr_block = cidrsubnet(cidrsubnet(aws_vpc.vpc.cidr_block, 2, 2), 8, count.index)
    cidr_block = cidrsubnet(aws_vpc.vpc.cidr_block, 8, count.index+10)
    availability_zone = data.aws_availability_zones.available_zones.names[count.index]
    tags = merge(var.project_common_tags, {
        Name = format("%s-private%s", local.subnet_name, count.index+1)
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
    tags = merge(var.project_common_tags, {
        Name = format("%s-public%s", local.subnet_name, count.index+1)
    })
    lifecycle {
        ignore_changes = [
            tags["Created_Date"]
        ]
    }
}

### INTERNET GATEWAY ###
# Criação do Internet Gateway (igw)
resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.vpc.id
    tags = merge(var.project_common_tags, {
        Name = format("%s", local.gateway_name)
    })
}

### ROUTE TABLE ###
# Criação da Route Table Pública (public_rtb)
resource "aws_route_table" "public_rtb" {
    vpc_id = aws_vpc.vpc.id
    tags = merge(var.project_common_tags, {
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
    tags = merge(var.project_common_tags, {
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

### NETWORK ACL ###
# Criação das politicas de segurança de rede para a subnet pública (nacl_public)
resource "aws_network_acl" "nacl_public" {
    vpc_id = aws_vpc.vpc.id
    subnet_ids = [for subnet in aws_subnet.public_subnet : subnet.id]
    tags = merge(var.project_common_tags, {
        Name = format("%s-public", local.acl_name)
    })
    ingress {
        rule_no = 10
        from_port = 0
        to_port = 0
        protocol = "icmp"
        cidr_block = format("%s", var.project_cidr-blocks["all"][0])
        action = "allow"
    }
    ingress {
        rule_no = 20
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_block = format("%s", var.project_cidr-blocks["all"][0])
        action = "allow"
    }
    ingress {
        rule_no = 30
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_block = format("%s", var.project_cidr-blocks["all"][0])
        action = "allow"
    }
    ingress {
        rule_no = 40
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_block = format("%s", var.project_cidr-blocks["all"][0])
        action = "allow"
    }
    ingress {
        rule_no = 50
        from_port = 3389
        to_port = 3389
        protocol = "tcp"
        cidr_block = format("%s", var.project_cidr-blocks["all"][0])
        action = "allow"
    }
    ingress {
        rule_no = 99
        from_port = 1024
        to_port = 65535
        protocol = "tcp"
        cidr_block = format("%s", var.project_cidr-blocks["all"][0])
        action = "allow"
    }
    ingress {
        rule_no = 100
        from_port = 1024
        to_port = 65535
        protocol = "udp"
        cidr_block = format("%s", var.project_cidr-blocks["all"][0])
        action = "allow"
    }
    egress {
        rule_no = 10
        from_port = 0
        to_port = 0
        protocol = "icmp"
        cidr_block = format("%s", var.project_cidr-blocks["all"][0])
        action = "allow"
    }
    egress {
        rule_no = 20
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_block = format("%s", var.project_cidr-blocks["all"][0])
        action = "allow"
    }
    egress {
        rule_no = 30
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_block = format("%s", var.project_cidr-blocks["all"][0])
        action = "allow"
    }
    egress {
        rule_no = 40
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_block = format("%s", var.project_cidr-blocks["all"][0])
        action = "allow"
    }
    egress {
        rule_no = 50
        from_port = 3389
        to_port = 3389
        protocol = "tcp"
        cidr_block = format("%s", var.project_cidr-blocks["all"][0])
        action = "allow"
    }
    egress {
        rule_no = 99
        from_port = 1024
        to_port = 65535
        protocol = "tcp"
        cidr_block = format("%s", var.project_cidr-blocks["all"][0])
        action = "allow"
    }
    egress {
        rule_no = 100
        from_port = 1024
        to_port = 65535
        protocol = "udp"
        cidr_block = format("%s", var.project_cidr-blocks["all"][0])
        action = "allow"
    }
    lifecycle {
        ignore_changes = [
            tags["Created_Date"]
        ]
    }
}

# Criação das politicas de segurança de rede para a subnet privada (nacl_private)
resource "aws_network_acl" "nacl_private" {
    vpc_id = aws_vpc.vpc.id
    subnet_ids = [for subnet in aws_subnet.private_subnet : subnet.id]
    tags = merge(var.project_common_tags, {
        Name = format("%s-private", local.acl_name)
    })
    ingress {
        rule_no = 10
        from_port = 0
        to_port = 0
        protocol = "icmp"
        cidr_block = format("%s", var.project_cidr-blocks["all"][0])
        action = "allow"
    }
    ingress {
        rule_no = 20
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_block = format("%s", var.project_cidr-blocks["all"][0])
        action = "allow"
    }
    ingress {
        rule_no = 30
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_block = format("%s", var.project_cidr-blocks["all"][0])
        action = "allow"
    }
    ingress {
        rule_no = 40
        from_port = 3306
        to_port = 3306
        protocol = "tcp"
        cidr_block = format("%s", var.project_cidr-blocks["all"][0])
        action = "allow"
    }
    ingress {
        rule_no = 99
        from_port = 1024
        to_port = 65535
        protocol = "tcp"
        cidr_block = format("%s", var.project_cidr-blocks["all"][0])
        action = "allow"
    }
    ingress {
        rule_no = 100
        from_port = 1024
        to_port = 65535
        protocol = "udp"
        cidr_block = format("%s", var.project_cidr-blocks["all"][0])
        action = "allow"
    }
    egress {
        rule_no = 10
        from_port = 0
        to_port = 0
        protocol = "icmp"
        cidr_block = format("%s", var.project_cidr-blocks["all"][0])
        action = "allow"
    }
    egress {
        rule_no = 20
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_block = format("%s", var.project_cidr-blocks["all"][0])
        action = "allow"
    }
    egress {
        rule_no = 30
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_block = format("%s", var.project_cidr-blocks["all"][0])
        action = "allow"
    }
    egress {
        rule_no = 40
        from_port = 3306
        to_port = 3306
        protocol = "tcp"
        cidr_block = format("%s", var.project_cidr-blocks["all"][0])
        action = "allow"
    }
    egress {
        rule_no = 99
        from_port = 1024
        to_port = 65535
        protocol = "tcp"
        cidr_block = format("%s", var.project_cidr-blocks["all"][0])
        action = "allow"
    }
    egress {
        rule_no = 100
        from_port = 1024
        to_port = 65535
        protocol = "udp"
        cidr_block = format("%s", var.project_cidr-blocks["all"][0])
        action = "allow"
    }
    lifecycle {
        ignore_changes = [
            tags["Created_Date"]
        ]
    }
}

### Instance A ###
resource "aws_instance" "instanceA" {
    ami = data.aws_ami.most_recent_ubuntu_ami.id
    instance_type = "t2.micro"
    key_name = "cloudtreinamentos_estudos" # Insira o nome do par de chaves criadas antes
    subnet_id = aws_subnet.public_subnet[0].id
    vpc_security_group_ids = [aws_security_group.allow_ssh_http_traffic.id]
    user_data = "${file("instance/user_dataA.sh")}"
    associate_public_ip_address = true
    tags = merge(var.project_common_tags, {
        Name = format("%sA", local.instance_name)
    })
}

### Instance B ###
resource "aws_instance" "instanceB" {
    ami = data.aws_ami.most_recent_ubuntu_ami.id
    instance_type = "t2.micro"
    key_name = "cloudtreinamentos_estudos" # Insira o nome do par de chaves criadas antes
    subnet_id = aws_subnet.public_subnet[1].id
    vpc_security_group_ids = [aws_security_group.allow_ssh_http_traffic.id]
    user_data = "${file("instance/user_dataB.sh")}"
    associate_public_ip_address = true
    tags = merge(var.project_common_tags, {
        Name = format("%sB", local.instance_name)
    })
}

### Security Group ###
resource "aws_security_group" "allow_ssh_http_traffic" {
    name = "allow_traffic"
    description = "Allow HTTP/TLS/SSH inbound traffic and all outbound traffic"
    vpc_id = aws_vpc.vpc.id
    tags = merge(var.project_common_tags, {
        Name = format("%s", local.sg_name)
    })
    ingress {
        description = "SSH Inbound"
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = [local.my_public_ip_address, var.project_cidr-blocks["ec2-connect"][0]]
    }
    ingress {
        description = "HTTP Inbound"
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = var.project_cidr-blocks["all"]
    }
    ingress {
        description = "HTTPS Inbound"
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = var.project_cidr-blocks["all"]
    }
    egress {
        description = "All traffic Outbound"
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = var.project_cidr-blocks["all"]
    }
    lifecycle {
        ignore_changes = [
            tags["Created_Date"]
        ]
    }
}

### ELB ###
# App Load Balancer
resource "aws_lb" "application_elb" {
    name = "webapp"
    internal = false
    load_balancer_type = "application"
    security_groups = [aws_security_group.allow_ssh_http_traffic.id]
    subnets = [aws_subnet.public_subnet[0].id, aws_subnet.public_subnet[1].id]
    tags = merge(var.project_common_tags, {
        Name = format("%s", local.elb_name)
    })
}

resource "aws_lb_target_group" "target_elb" {
    name = "ALB-TG"
    port = 80
    protocol = "HTTP"
    vpc_id = aws_vpc.vpc.id
    health_check {
        path = "/"
        port = 80
        protocol = "HTTP"
    }
}

resource "aws_lb_target_group_attachment" "instanceA" {
    target_group_arn = aws_lb_target_group.target_elb.arn
    target_id  = aws_instance.instanceA.id
    port = 80
    depends_on = [
        aws_lb_target_group.target_elb,
        aws_instance.instanceA
    ]
}

resource "aws_lb_target_group_attachment" "instanceB" {
    target_group_arn = aws_lb_target_group.target_elb.arn
    target_id = aws_instance.instanceB.id
    port = 80
    depends_on = [
        aws_lb_target_group.target_elb,
        aws_instance.instanceB
    ]
}

resource "aws_lb_listener" "listener_elb" {
    load_balancer_arn = aws_lb.application_elb.arn
    port = 80
    protocol = "HTTP"
    default_action {
        type = "forward"
        target_group_arn = aws_lb_target_group.target_elb.arn
    }
}