resource "aws_lb" "application_elb" {
    name = "ASG-Prova-Modulo-06"
    internal = false
    load_balancer_type = "application"
    subnets = [for subnet in aws_subnet.public_subnets : subnet.id]
    security_groups = [aws_security_group.allow_ssh_http_traffic.id]
}

resource "aws_lb_target_group" "target_elb" {
    name = "ALB-TG-Prova-Modulo-06"
    port = 80
    protocol = "HTTP"
    vpc_id = aws_vpc.vpc.id
    health_check {
        path = "/"
        port = 80
        protocol = "HTTP"
    }
}

resource "aws_lb_listener" "listener_elb" {
    load_balancer_arn = aws_lb.application_elb.arn
    port = 80
    protocol = "HTTP"
    default_action {
        type = "forward"
        target_group_arn = aws_lb_target_group.target_elb.arn
    }
}

resource "aws_autoscaling_attachment" "attachment" {
  autoscaling_group_name = aws_autoscaling_group.autoscale.id
  lb_target_group_arn = aws_lb_target_group.target_elb.arn
}
