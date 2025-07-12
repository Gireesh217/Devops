variable "target_accounts" {
  description = "Map of target accounts to attach the policy to"
  type = map(object({
    id      = string
    enabled = bool
  }))
}

variable "DenyS3BucketModifications_Name" {
  description = "SCP Policy for Modification and Deletion of S3 Bucket at Organisation Level"
  type = string
}

variable "aws_region" {
  type = string
}

variable "root_profile" {
  type = string
}