variable "eks_deny_iam_policy_name" {
  description = "EKS Deny IAM Actions Policy Name"
  type = string
}

variable "target_accounts" {
  description = "Map of target accounts to attach the policy to"
  type = map(object({
    id      = string
    enabled = bool
  }))
}

variable "aws_region" {
  type = string
}

variable "root_profile" {
  type = string
}
