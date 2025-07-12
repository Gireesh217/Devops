# restrict to download option on particular bucket
resource "aws_organizations_policy" "deny_download_s3_folder12" {
  name        = "DenyDownloadS3Folder"
  type        = "SERVICE_CONTROL_POLICY"
  description = "Deny download (s3:GetObject), list (s3:ListBucket), delete (s3:DeleteObject), and create (s3:CreateBucket) for a specific folder in S3 bucket"

  content = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Deny"
        Action    = [
          "s3:GetObject",
          "s3:ListBucket",
          "s3:DeleteObject"
        ]
        Resource  = [
          "arn:aws:s3:::treeeee/*"
        ]
      },
      {
        Effect    = "Deny"
        Action    = "s3:CreateBucket"
        Resource  = "*"
      }
    ]
  })
}

# Attach the SCP to an AWS Organization account or Organizational Unit (OU)
resource "aws_organizations_policy_attachment" "deny_download_s3_folder_attachment" {
  policy_id = aws_organizations_policy.deny_download_s3_folder12.id
  target_id = "061039807985"  # Specify the OU ID or account ID here
}
