module "mw_s3" {
  source        = "../modules/s3"
  s3_names      = var.s3_names
  s3_versioning = var.s3_versioning
  tags          = var.tags
}

resource "aws_dynamodb_table" "tf_lock" {
  name         = "terraform-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}
