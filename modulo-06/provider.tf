# Configure the provider
provider "aws" {
    region = var.project_region
    access_key = var.project_accessKey
    secret_key = var.project_secretKey

    # default_tags {
    #     tags = {
    #         Environment = "Test"
    #         Project = var.project_name
    #         Customer = var.project_customer
    #         Created_Date = formatdate("YYYY-MM-DD hh:mm:ss ZZZ", timestamp())
    #         Modified_Date = formatdate("YYYY-MM-DD hh:mm:ss ZZZ", timestamp())
    #         Created_By = "Terraform"
    #     }
    # }
}
