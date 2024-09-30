output "url" {
    value = aws_s3_bucket_website_configuration.website-config.website_endpoint
}