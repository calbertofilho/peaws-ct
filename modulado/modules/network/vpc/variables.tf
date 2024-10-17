variable "vpc_name" {
    type = string
}

variable "vpc_cidr_block" {
    type = string
}

variable "enable_dns_hostnames" {
    type = bool
    description = "Enable DNS hostname"
}

variable "enable_dns_support" {
    type = bool
    description = "Enable DNS support"
}

variable "azs" {
    type = list(string)
    description = "Availability Zones"
}

variable "total_azs_to_create" {
    type = number
    description = "Number of Availability Zones to be created"
}

variable "common_tags" {
    type = map(string)
    description = "Common tags"
}