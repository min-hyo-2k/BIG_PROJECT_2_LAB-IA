output "bucket_id" {
  description = "the bucket id"
  value       = aws_s3_bucket.main[0].id
}
