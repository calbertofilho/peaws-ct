# Configure the provider
provider "aws" {
    region = var.project_region
    access_key = var.project_accessKey
    secret_key = var.project_secretKey
}
