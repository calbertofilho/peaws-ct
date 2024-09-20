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