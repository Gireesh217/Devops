output "policy_id" {
  description = "The ID of the created Organizations Policy"
  value       = aws_organizations_policy.require_specific_ec2_iam_profile.id
}
 
output "policy_arn" {
  description = "The ARN of the created Organizations Policy"
  value       = aws_organizations_policy.require_specific_ec2_iam_profile.arn
}
 
output "attached_targets" {
  description = "List of target IDs where the policy is attached"
  value       = [for k, v in var.target_accounts : v.id if v.enabled]
}
 