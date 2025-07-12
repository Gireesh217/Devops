# Create the IAM policy to prevent S3 modification and deletion

resource "aws_iam_policy" "prevent_s3_modification_deletion" {
  name        = "var.PreventS3ModificationDeletion"
  description = "IAM policy to prevent modification or deletion of S3 buckets and objects"
  policy      = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Deny"
        Action    = [
          "s3:DeleteBucket",
          "s3:PutBucket*",
          "s3:PutBucketAcl",
          "s3:PutBucketPolicy",
          "s3:PutBucketCors",
          "s3:PutBucketLifecycle",
          "s3:PutBucketLogging",
          "s3:PutBucketTagging",
          "s3:PutBucketVersioning",
          "s3:PutBucketWebsite"
        ]
        Resource  = "arn:aws:s3:::*"
      },
      {
        Effect    = "Deny"
        Action    = [
          "s3:DeleteObject",
          "s3:DeleteObjectVersion"
        ]
        Resource  = "arn:aws:s3:::*/*"
      }
    ]
  })
}

# Create the IAM role
resource "aws_iam_role" "s3_protection_role" {
  name               = "var.aws_iam_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Action    = "sts:AssumeRole"  # This must specify sts:AssumeRole
        Principal = {
           "Service": "s3.amazonaws.com"
        }
      }
    ]
  })
}

# Attach the policy to the IAM role
resource "aws_iam_role_policy_attachment" "attach_prevent_s3_policy_to_role" {
  role       = aws_iam_role.s3_protection_role.name
  policy_arn = aws_iam_policy.prevent_s3_modification_deletion.arn
}

