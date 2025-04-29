locals {

  name_suffix = "${lookup(var.tags, "Environment")}-${lookup(var.tags, "Project")}"

}

# the s3 creation
resource "aws_s3_bucket" "my_s3" {
  count                    = length(var.s3_names)
  bucket = "${var.s3_names[count.index]}-${local.name_suffix}"
  tags = {
    Name        = "s3-${local.name_suffix}"
    Owner       = lookup(var.tags, "Owner")
    Application = "storage" #lookup(var.tags, "Application")
    Project     = lookup(var.tags, "Project")
    Environment = lookup(var.tags, "Environment")
  }
}

#versionning
resource "aws_s3_bucket_versioning" "my_s3_versioning" {
  count                    = length(var.s3_names)
  bucket = aws_s3_bucket.my_s3[count.index].id
  versioning_configuration {
    status = var.s3_versioning
  }
}

#server side encruption
resource "aws_s3_bucket_server_side_encryption_configuration" "my_s3_encryption" {
  count                    = length(var.s3_names)
  bucket = aws_s3_bucket.my_s3[count.index].id
  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = null
      sse_algorithm     = "aws:kms"
    }
  }
}