output "ssm_managed_instance_policy_arn" {
  description = "ARN of the SSM Managed Instance Policy"
  value       = aws_iam_policy.ssm_managed_instance_policy.arn
}
 
output "ec2_launch_with_ssm_policy_arn" {
  description = "ARN of the EC2 Launch with SSM"
  value = aws_iam_policy.ec2_launch_with_ssm_policy.arn
}