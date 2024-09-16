# Module that defines all project variables

variable "project_name" {
    description = "Define the project name"
    type = string
}

variable "project_customer" {
    description = "Define the project customer name"
    type = string
}

variable "project_provider" {
    description = "Define the provider"
    type = string
}

variable "project_region" {
    description = "Define AWS region"
    type = string
}
