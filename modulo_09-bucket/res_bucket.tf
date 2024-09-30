resource "aws_s3_bucket" "website" {
    bucket = local.bucket_name
    tags = merge(local.common_tags, {
    # tags = {
        Name = format("%s", local.bucket_name)
    # }
    })
}

resource "aws_s3_bucket_ownership_controls" "website-ownership" {
    bucket = aws_s3_bucket.website.id
    rule {
        object_ownership = "BucketOwnerPreferred"
    }
}

resource "aws_s3_bucket_public_access_block" "website-publiceaccess" {
    bucket = aws_s3_bucket.website.id
    block_public_acls = false
    block_public_policy = false
    ignore_public_acls = false
    restrict_public_buckets = false
}

resource "aws_s3_bucket_acl" "website-acl" {
    depends_on = [
        aws_s3_bucket_ownership_controls.website-ownership,
        aws_s3_bucket_public_access_block.website-publiceaccess,
    ]
    bucket = aws_s3_bucket.website.id
    acl = "public-read"
}

resource "aws_s3_bucket_versioning" "website-versioning" {
    bucket = aws_s3_bucket.website.id
    versioning_configuration {
        status = "Enabled"
    }
}

resource "aws_s3_object" "index_page" {
    bucket = aws_s3_bucket.website.id
    key = "index.html"
    content_type = "text/html; charset=UTF-8"
    source = "site/index.html"
    etag = filemd5("site/index.html")
}

resource "aws_s3_object" "error_page" {
    bucket = aws_s3_bucket.website.id
    key = "error.html"
    content_type = "text/html; charset=UTF-8"
    source = "site/error.html"
    etag = filemd5("site/error.html")
}

resource "aws_s3_object" "imagens_folder" {
    for_each = fileset("site/imagens", "**/*") 
    bucket = aws_s3_bucket.website.id
    key = "imagens/${each.key}"
    source = "site/imagens/${each.key}" 
    etag = filemd5("site/imagens/${each.key}")
}

resource "aws_s3_bucket_website_configuration" "website-config" {
    bucket = aws_s3_bucket.website.id
    index_document {
        suffix = "index.html"
    }
    error_document {
        key = "error.html"
    }
    routing_rule {
        condition {
            key_prefix_equals = "imagens/*"
        }
        redirect {
            replace_key_prefix_with = "imagens/*"
        }
    }
}

resource "aws_s3_bucket_policy" "website-policy" {
    bucket = aws_s3_bucket.website.id
    policy = data.aws_iam_policy_document.allow_public_read_access.json
}
