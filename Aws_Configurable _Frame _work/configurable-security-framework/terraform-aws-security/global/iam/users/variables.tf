
variable "iam_users" {
  description = "List of IAM users with enable flag to attach the policy"
  type = list(object({
    name   = string
    enable = bool
  }))
}
 
variable "ec2_launch_with_ssm_policy_arn" {
  description = "ARN of the EC2 launch with SSM policy to attach"
  type        = string
}
 