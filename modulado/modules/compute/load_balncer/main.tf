### ELB ###
# App Load Balancer
resource "aws_lb" "application_elb" {
    name = "webapp"
    internal = false
    load_balancer_type = "application"
    security_groups = [aws_security_group.allow_ssh_http_traffic.id]
    subnets = [aws_subnet.public_subnet[0].id, aws_subnet.public_subnet[1].id]
    tags = merge(local.common_tags, {
        Name = format("%s", local.elb_name)
    })
}

resource "aws_lb_target_group" "target_elb" {
    name = "ALB-TG"
    port = 80
    protocol = "HTTP"
    vpc_id = aws_vpc.vpc.id
    health_check {
        path = "/"
        port = 80
        protocol = "HTTP"
    }
}

resource "aws_lb_target_group_attachment" "instanceA" {
    target_group_arn = aws_lb_target_group.target_elb.arn
    target_id  = aws_instance.instanceA.id
    port = 80
    depends_on = [
        aws_lb_target_group.target_elb,
        aws_instance.instanceA
    ]
}

resource "aws_lb_target_group_attachment" "instanceB" {
    target_group_arn = aws_lb_target_group.target_elb.arn
    target_id = aws_instance.instanceB.id
    port = 80
    depends_on = [
        aws_lb_target_group.target_elb,
        aws_instance.instanceB
    ]
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