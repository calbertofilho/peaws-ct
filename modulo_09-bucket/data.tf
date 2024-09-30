# Consulta o meu IP publico
data "external" "myipaddr" {
    program = ["bash", "-c", "curl -s 'https://ipinfo.io/json'"]
}

data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "allow_public_read_access" {
    statement {
        principals {
            type = "*"
            identifiers = ["*"]
        }
        actions = [
            "s3:GetObject"
        ]
        resources = [
            "${aws_s3_bucket.website.arn}",
            "${aws_s3_bucket.website.arn}/*"
        ]
    }
}
