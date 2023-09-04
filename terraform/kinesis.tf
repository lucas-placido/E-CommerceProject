resource "aws_kinesis_firehose_delivery_stream" "extended_s3_stream" {
  name        = "firehose-reviews-stream"
  destination = "extended_s3"

  extended_s3_configuration {
    role_arn   = aws_iam_role.firehose_role.arn
    bucket_arn = aws_s3_bucket.olist_landing_zone.arn
	buffering_interval = 60

	cloudwatch_logging_options {
      enabled = true
      log_group_name = "firehose"
      log_stream_name = "reviews-delivery"
    }
  }
  depends_on = [ aws_iam_role_policy.firehose_policy, aws_iam_role.firehose_role ]
}

# IAM Role
resource "aws_iam_role" "firehose_role" {
  name = "reviews-stream-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "firehose.amazonaws.com"
        }
      },
    ]
  })
  description = "Allow Kinesis data firehose to assume the role"
}

resource "aws_iam_role_policy" "firehose_policy" {
  name = "reviews-stream-policy"
  role = aws_iam_role.firehose_role.id
  
  policy = jsonencode({
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "Stmt1693128675790",
      "Action": "s3:*",
      "Effect": "Allow",
      "Resource": [aws_s3_bucket.olist_landing_zone.arn, 
	  				"${aws_s3_bucket.olist_landing_zone.arn}/*"]
    		}
		]
	})
}