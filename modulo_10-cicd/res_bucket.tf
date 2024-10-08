resource "aws_s3_bucket" "mybucket" {
    bucket = local.bucket_name
    tags = merge(local.common_tags, {
    # tags = {
        Name = format("%s", local.bucket_name)
    # }
    })
}

resource "aws_s3_object" "app_package" {
    bucket = aws_s3_bucket.mybucket.id
    key = "app.zip"
    content_type = "application/zip; charset=UTF-8"
    source = "pipeline_cicd/app.zip"
    etag = filemd5("pipeline_cicd/app.zip")
}
