### Security Group ###
resource "aws_security_group" "allow_ssh_http_traffic" {
    name = "allow_traffic"
    description = "Allow HTTP/TLS/SSH inbound traffic and all outbound traffic"
    vpc_id = aws_vpc.vpc.id
    tags = merge(local.common_tags, {
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