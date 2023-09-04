resource "aws_s3_bucket" "olist_landing_zone" {
  bucket = "olist-raw-data-${random_id.bucket_suffix.hex}"
}

resource "random_id" "bucket_suffix" {
  byte_length = 4
}