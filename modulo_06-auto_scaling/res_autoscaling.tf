# Você deve criar 1 instancia com a imagem disponibilizada no modulo (ami-0ad49176e48491d33)
# que esta na região us-east-1 e configurar para adicionar outra instancia quando processamento
# for maior que 70% e excluir quando o processamento for menos que 30%.

resource "aws_launch_template" "template" {
    name_prefix = "prova-modulo_06-"
    image_id = "ami-0ad49176e48491d33"
    instance_type = "t2.micro"
    key_name = "cloudtreinamentos_estudos" # Insira o nome do par de chaves criadas antes
    vpc_security_group_ids = [aws_security_group.allow_ssh_http_traffic.id]
    metadata_options {
        http_tokens = "optional"
    }
    tag_specifications {
        resource_type = "instance"

        tags = {
            Name = "ASG_Prova-Modulo_06"
        }
    }
    lifecycle {
        create_before_destroy = true
    }
}

resource "aws_autoscaling_group" "autoscale" {
    name = "prova-autoscaling-group"
    vpc_zone_identifier = [for subnet in aws_subnet.public_subnets : subnet.id]
    load_balancers = aws_lb_target_group.target_elb.load_balancer_arns
    health_check_type = "EC2"
    health_check_grace_period = 120
    enabled_metrics = [
        "GroupDesiredCapacity",
        "GroupInServiceCapacity",
        "GroupPendingCapacity",
        "GroupMinSize",
        "GroupMaxSize",
        "GroupInServiceInstances",
        "GroupPendingInstances",
        "GroupStandbyInstances",
        "GroupStandbyCapacity",
        "GroupTerminatingCapacity",
        "GroupTerminatingInstances",
        "GroupTotalCapacity",
        "GroupTotalInstances"
    ]
    metrics_granularity = "1Minute"
    desired_capacity = 1
    max_size = 2
    min_size = 1
    termination_policies = ["OldestInstance"]

    launch_template {
        id = aws_launch_template.template.id
        version = "$Latest"
    }
}

resource "aws_autoscaling_policy" "scale_up" {
    name = "prova_modulo_06-scale_up_policy"
    scaling_adjustment = 1
    adjustment_type = "ChangeInCapacity"
    cooldown = 120 # Aguardar antes de permitir outra acao de autoscaling
    autoscaling_group_name = aws_autoscaling_group.autoscale.name
    policy_type = "SimpleScaling"
}

resource "aws_autoscaling_policy" "scale_down" {
    name = "prova_modulo_06-scale_down_policy"
    scaling_adjustment = -1
    adjustment_type = "ChangeInCapacity"
    cooldown = 120
    autoscaling_group_name = aws_autoscaling_group.autoscale.name
    policy_type = "SimpleScaling"
}

resource "aws_cloudwatch_metric_alarm" "ec2_scale_up-cloudwatch_alarm" {
    alarm_name = "ec2_scale_up-cloudwatch_alarm"
    comparison_operator = "GreaterThanOrEqualToThreshold"
    evaluation_periods = 1
    metric_name = "CPUUtilization"
    namespace = "AWS/EC2"
    period = 300
    statistic = "Average"
    threshold = 70
    alarm_description = "This metric monitors ec2 cpu utilization, if it goes above 70% for 1 period it will trigger an alarm."
    insufficient_data_actions = []

    alarm_actions = [
        "${aws_autoscaling_policy.scale_up.arn}"
    ]
}

resource "aws_cloudwatch_metric_alarm" "ec2_scale_down-cloudwatch_alarm" {
  alarm_name = "ec2_scale_down-cloudwatch_alarm"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods = 1
  metric_name = "CPUUtilization"
  namespace = "AWS/EC2"
  period = 300
  statistic = "Average"
  threshold = 30
  alarm_description = "This metric monitors ec2 cpu utilization, if it goes below 30% for 1 period it will trigger an alarm."
  insufficient_data_actions = []

  alarm_actions = [
      "${aws_autoscaling_policy.scale_down.arn}"
  ]
}
