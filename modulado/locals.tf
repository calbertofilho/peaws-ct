locals {
    my_public_ip_address = format("%s/%s", data.external.myipaddr.result["ip"], 32)
    name = format("%s.%s.%s", data.aws_caller_identity.current.id, var.project_customer, var.project_name)
    common_tags = {
        Environment = "Test"
        Project = var.project_name
        Customer = var.project_customer
        Created_Date = formatdate("YYYY-MM-DD hh:mm:ss ZZZ", timestamp())
        Modified_Date = formatdate("YYYY-MM-DD hh:mm:ss ZZZ", timestamp())
        Developer = "Carlos Alberto Filho"
        Created_By = "Terraform"
    }
}