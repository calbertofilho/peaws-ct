output "vpc_id" {
  description = "ID of project VPC"
  value = aws_vpc.vpc.id
}

output "lb_url" {
  description = "URL of load balancer"
  value = "http://${aws_lb.application_elb.dns_name}/"
}