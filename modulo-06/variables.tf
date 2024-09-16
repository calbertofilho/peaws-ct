# Definitions that may contains any sensitive data, such as passwords,
# private keys, and other secrets, must be declared in other .tfvars
# file named secrets.tfvars or secrets.tfvars.json
#
# These should not be part of version control as they are data points
# which are potentially sensitive and subject to change depending on
# the environment.

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
