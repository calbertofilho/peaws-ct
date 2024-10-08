data aws_iam_policy_document "codedeploy_assume_role" {
    statement {
        actions = ["sts:AssumeRole"]

        principals {
            type        = "Service"
            identifiers = ["codedeploy.amazonaws.com"]
        }
    }
}

resource "aws_iam_role" "codedeploy_iam_role" {
    name = "codedeploy_iam_role"
    assume_role_policy = "${data.aws_iam_policy_document.codedeploy_assume_role.json}"
}

resource "aws_iam_role_policy_attachment" "codedeploy-policy" {
    role = aws_iam_role.codedeploy_iam_role.name
    policy_arn = "arn:aws:iam::aws:policy/service-role/AWSCodeDeployRole"
}

data aws_iam_policy_document "ec2_assume_role" {
    statement {
        actions = ["sts:AssumeRole"]

        principals {
            type        = "Service"
            identifiers = ["ec2.amazonaws.com"]
        }
    }
}

data aws_iam_policy_document "s3_read_access" {
    statement {
        actions = ["s3:Get*", "s3:List*"]

        resources = ["arn:aws:s3:::*"]
    }
}

resource "aws_iam_role" "ec2_iam_role" {
    name = "ec2_iam_role"
    assume_role_policy = "${data.aws_iam_policy_document.ec2_assume_role.json}"
}

resource "aws_iam_role_policy" "join_policy" {
    depends_on = [aws_iam_role.ec2_iam_role]
    name = "EC2-S3_ReadOnly-Role"
    role = "${aws_iam_role.ec2_iam_role.name}"
    policy = "${data.aws_iam_policy_document.s3_read_access.json}"
}

# AmazonSSMManagedInstanceCore
resource "aws_iam_role_policy_attachment" "dev-resources-ssm-policy" {
    role = aws_iam_role.ec2_iam_role.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "instance_profile" {
    name = "EC2_S3-instance_profile"
    role = "${aws_iam_role.ec2_iam_role.name}"
}
