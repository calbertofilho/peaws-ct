### Instance A ###
resource "aws_instance" "instanceA" {
    ami = data.aws_ami.most_recent_ubuntu_ami.id
    instance_type = "t2.micro"
    key_name = "cloudtreinamentos_estudos" # Insira o nome do par de chaves criadas antes
    subnet_id = aws_subnet.public_subnet[0].id
    vpc_security_group_ids = [aws_security_group.allow_ssh_http_traffic.id]
    user_data = "${file("instance/user_dataA.sh")}"
    associate_public_ip_address = true
    tags = merge(local.common_tags, {
        Name = format("%sA", local.instance_name)
    })
}

### Instance B ###
resource "aws_instance" "instanceB" {
    ami = data.aws_ami.most_recent_ubuntu_ami.id
    instance_type = "t2.micro"
    key_name = "cloudtreinamentos_estudos" # Insira o nome do par de chaves criadas antes
    subnet_id = aws_subnet.public_subnet[1].id
    vpc_security_group_ids = [aws_security_group.allow_ssh_http_traffic.id]
    user_data = "${file("instance/user_dataB.sh")}"
    associate_public_ip_address = true
    tags = merge(local.common_tags, {
        Name = format("%sB", local.instance_name)
    })
}