# Criação das politicas de segurança de rede para a subnet pública (nacl_public)
resource "aws_network_acl" "nacl_public" {
    vpc_id = aws_vpc.vpc.id
    subnet_ids = [for subnet in aws_subnet.public_subnet : subnet.id]
    tags = merge(local.common_tags, {
    # tags = {
        Name = format("%s-public", local.acl_name)
    # }
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
    tags = merge(local.common_tags, {
    # tags = {
        Name = format("%s-private", local.acl_name)
    # }
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

resource "aws_security_group" "allow_ssh_http_traffic" {
    name = "allow_traffic"
    description = "Allow HTTP/TLS/SSH inbound traffic and all outbound traffic"
    vpc_id = aws_vpc.vpc.id
    tags = merge(local.common_tags, {
    # tags = {
        Name = format("%s", local.sg_name)
    # }
    })

    ingress {
        description = "SSH Inbound"
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = local.my_public_ip_address
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