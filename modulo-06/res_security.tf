resource "aws_network_acl" "infra" {
    vpc_id = aws_vpc.vpc.id
    tags = merge(local.common_tags, {
    # tags = {
        Name = format("%s-acl", var.project_name)
    # }
    })

    ingress = []

    egress = []

    lifecycle {
        ignore_changes = [
            tags["Created_Date"]
        ]
    }
}

resource "aws_security_group" "example" {
    name        = "allow_tls"
    description = "Allow TLS inbound traffic and all outbound traffic"
    vpc_id = aws_vpc.vpc.id
    tags = merge(local.common_tags, {
    # tags = {
        Name = format("%s-sg", var.project_name)
    # }
    })

    ingress = []

    egress = []

    lifecycle {
        ignore_changes = [
            tags["Created_Date"]
        ]
    }
}
