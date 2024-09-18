# Consulta das zonas disponiveis na regiao selecionada
data "aws_availability_zones" "available_zones" {
    state = "available"
    filter {
        name = "region-name"
        values = [var.project_region]
    }
}
