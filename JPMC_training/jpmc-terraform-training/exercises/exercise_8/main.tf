provider "aws" {
  region = "eu-west-1"
}

# Create a KMS Key with a policy
resource "aws_kms_key" "s3_key" {
  description         = "KMS key for S3 encryption"
  enable_key_rotation = true

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "Enable IAM User Permissions"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::061039807985:root"
        }
        Action   = "kms:*"
        Resource = "*"
      },
      {
        Sid    = "Allow access for Key Administrators"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::061039807985:user/gireesh.test"
        }
        Action = [
          "kms:Create*",
          "kms:Describe*",
          "kms:Enable*",
          "kms:List*",
          "kms:Put*",
          "kms:Update*",
          "kms:Revoke*",
          "kms:Disable*",
          "kms:Get*",
          "kms:Delete*",
          "kms:TagResource",
          "kms:UntagResource",
          "kms:ScheduleKeyDeletion",
          "kms:CancelKeyDeletion",
          "kms:RotateKeyOnDemand"
        ]
        Resource = "*"
      },
      {
        Sid    = "Allow use of the key"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::061039807985:user/akash.test"
        }
        Action = [
          "kms:Encrypt",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*",
          "kms:DescribeKey"
        ]
        Resource = "*"
      },
      {
        Sid    = "Allow attachment of persistent resources"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::061039807985:user/akash.test"
        }
        Action = [
          "kms:CreateGrant",
          "kms:ListGrants",
          "kms:RevokeGrant"
        ]
        Resource = "*"
        Condition = {
          Bool = {
            "kms:GrantIsForAWSResource" = "true"
          }
        }
      }
    ]
  })
}

# Create an S3 bucket
resource "aws_s3_bucket" "my_bucket" {
  bucket = "my-encrypted-s3-bucket"
}

# Enable S3 Bucket Key for KMS encryption using a separate resource
resource "aws_s3_bucket_server_side_encryption_configuration" "my_bucket_encryption" {
  bucket = aws_s3_bucket.my_bucket.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm    = "aws:kms"
      kms_master_key_id = aws_kms_key.s3_key.arn
    }

    # Enable the Bucket Key
    bucket_key_enabled = true
  }
}

# Create an S3 object and apply KMS encryption
resource "aws_s3_object" "encrypted_object" {
  bucket = aws_s3_bucket.my_bucket.bucket
  key    = "Kms-encryption.txt"
  source = "C:/Users/dabbugunta_g/Desktop/Kms-encryption.txt" # Update this to the correct path

  # Specify the KMS key for encryption
  server_side_encryption = "aws:kms"
  kms_key_id             = aws_kms_key.s3_key.arn
}

# Create IAM policy for user to allow access to S3 bucket with encryption/decryption
resource "aws_iam_policy" "s3_encryption_policy" {
  name        = "S3EncryptionPolicy"
  description = "Allow access to encrypted S3 bucket objects"
  policy      = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject"
        ]
        Resource = "${aws_s3_bucket.my_bucket.arn}/*"
      },
      {
        Effect = "Allow"
        Action = [
          "kms:Encrypt"
        ]
        Resource = aws_kms_key.s3_key.arn
      }
    ]
  })
}

# Attach policy to user (akash.test)
resource "aws_iam_user_policy_attachment" "user_policy_attachment" {
  user       = "akash.test"
  policy_arn = aws_iam_policy.s3_encryption_policy.arn
}
