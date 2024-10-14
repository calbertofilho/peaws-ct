locals {
    my_public_ip_address = format("%s/%s", data.external.myipaddr.result["ip"], 32)
    vpc_name = format("%s-%s-vpc", var.project_customer, var.project_name)
    subnet_name = format("%s-%s-net", var.project_customer, var.project_name)
    gateway_name = format("%s-%s-igw", var.project_customer, var.project_name)
    route_name = format("%s-%s-rtb", var.project_customer, var.project_name)
    acl_name = format("%s-%s-acl", var.project_customer, var.project_name)
    sg_name = format("%s-%s-sg", var.project_customer, var.project_name)
    instance_name = format("%s-%s-ec2", var.project_customer, var.project_name)
    elb_name = format("%s-%s-alb", var.project_customer, var.project_name)
}