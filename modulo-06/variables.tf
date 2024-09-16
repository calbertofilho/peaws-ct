# Module that defines all project variables

variable "project_name" {
    description = "Define the project name"
    type = string
    default = "modulo-6"
}

variable "project_customer" {
    description = "Define the project customer name"
    type = string
    default = "cloud_treinamentos"
}

variable "project_provider" {
    description = "Define the provider"
    type = string
    default = "aws"
}

variable "project_region" {
    description = "Define AWS region"
    type = string
    default = "us-east-1"
}
