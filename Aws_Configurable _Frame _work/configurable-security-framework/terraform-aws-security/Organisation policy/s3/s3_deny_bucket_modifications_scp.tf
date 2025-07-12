provider "aws" {
  region =  var.aws_region
  profile = var.root_profile
}
resource "aws_organizations_policy" "deny_s3_modifications" {
  name        = var.DenyS3BucketModifications_Name
  description = "Prevents modification or deletion of S3 buckets and objects"
  content     = <<JSON
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Deny",
      "Action": [
        "s3:DeleteBucket",
        "s3:DeleteBucketPolicy",
        "s3:PutBucketPolicy",
        "s3:PutBucketAcl",
        "s3:DeleteObject",
        "s3:PutObject"
      ],
      "Resource": "arn:aws:s3:::*"
    },
    {
      "Effect": "Deny",
      "Action": [
        "s3:DeleteBucket",
        "s3:PutBucketAcl",
        "s3:PutBucketPolicy"
      ],
      "Resource": "arn:aws:s3:::*/*"
    },
    {
      "Sid": "AllowS3ProtectionRoleToDeletePolicy",
      "Effect": "Deny",
      "Action": "organizations:DeletePolicy",
      "Resource": "*",
      "Condition": {
        "StringEqualsIfExists": {
          "aws:PrincipalTag/RoleName": "S3ProtectionRole"
        }
      }
    }
  ]
}
JSON
}

resource "aws_organizations_policy_attachment" "attach_deny_S3_modifications" {
  for_each = {
    for k, v in var.target_accounts : k => v
    if v.enabled
  }
  policy_id = aws_organizations_policy.deny_s3_modifications.id
  target_id = each.value.id
}


