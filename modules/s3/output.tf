output "buckets_name" {
  value = aws_s3_bucket.my_s3[*].bucket
}