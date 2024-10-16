# Consulta o meu IP publico
data "external" "myipaddr" {
    program = ["bash", "-c", "curl -s 'https://ipinfo.io/json'"]
}

# Consulta das zonas disponiveis na regiao selecionada
data "aws_availability_zones" "available_zones" {
    state = "available"
    filter {
        name = "region-name"
        values = [var.project_region]
    }
}

# Consulta a ami mais recente do Ubuntu
data "aws_ami" "most_recent_ubuntu_ami" {
    most_recent = true
    filter {
        name = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-*-amd64-server-*"]
    }
    filter {
        name = "virtualization-type"
        values = ["hvm"]
    }
    owners = ["099720109477"]   # Canonical Id
}

# Consulta a ami mais recente do Amazon Linux 2
data "aws_ami" "most_recent_amazon2_ami" {
    most_recent = true
    filter {
        name = "name"
        values = ["amzn2-ami-hvm-*-x86_64-ebs"]
    }
    filter {
        name = "virtualization-type"
        values = ["hvm"]
    }
    owners = ["amazon"]
}

# Account Id
data "aws_caller_identity" "current" {}