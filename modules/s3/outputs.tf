output "bucket_name" {
  value = aws_s3_bucket.frontend.bucket
}

output "bucket_domain" {
  value = aws_s3_bucket.frontend.bucket_domain_name
}
