#Create S3 bucket
resource "aws_s3_bucket" "todolist_static_site" {
  bucket = "frontend-flask-todolist-4187"

  tags = {
    Type = "frontend"
  }
}

#Upload index.html to the S3 bucket
resource "aws_s3_object" "index_html" {
  bucket       = aws_s3_bucket.todolist_static_site.bucket
  key          = "index.html"
  content      = templatefile("${path.module}/templates/index.tpl", { backend_url = module.target-node-1.public_ip }) #change this to the backend ip
  content_type = "text/html"
  acl          = "public-read"
}

#Set bucket ownership
resource "aws_s3_bucket_ownership_controls" "todolist_static_site_ownership" {
  bucket = aws_s3_bucket.todolist_static_site.bucket

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

#Set bucket public access
resource "aws_s3_bucket_public_access_block" "todolist_static_site_access_block" {
  bucket = aws_s3_bucket.todolist_static_site.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

#Set bucket acl
resource "aws_s3_bucket_acl" "todolist_static_site_acl" {
  depends_on = [
    aws_s3_bucket_ownership_controls.todolist_static_site_controls,
    aws_s3_bucket_public_access_block.todolist_static_site_access_block,
  ]

  bucket = aws_s3_bucket.todolist_static_site.id
  acl    = "public-read"
}

resource "aws_s3_bucket_website_configuration" "s3_static_site_configuration" {
  bucket = aws_s3_bucket.todolist_static_site.bucket

  index_document {
    suffix = "index.html"
  }
}

resource "aws_s3_bucket_policy" "static_site_policy" {
  depends_on = [
    aws_s3_bucket.todolist_static_site,
    aws_s3_bucket_ownership_controls.todolist_static_site_controls,
    aws_s3_bucket_public_access_block.todolist_static_site_access_block,
    aws_s3_bucket_acl.todolist_static_site_acl,
    aws_s3_bucket_website_configuration.s3_static_site_configuration
  ]

  bucket = aws_s3_bucket.todolist_static_site.bucket

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect    = "Allow",
        Principal = "*",
        Action    = "s3:GetObject",
        Resource  = "${aws_s3_bucket.todolist_static_site.arn}/*",
      },
    ],
  })
}