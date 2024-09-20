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
        # values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
        values = ["ubuntu/images/hvm-ssd/ubuntu-*-amd64-server-*"]
    }

    filter {
        name = "virtualization-type"
        values = ["hvm"]
    }
    # Id da Canonical
    owners = ["099720109477"]
}