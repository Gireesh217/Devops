variable "ssm_role_name" {
  description = "Name of the SSM managed instance role"
  type        = string
}
 
variable "ssm_instance_profile_name" {
  description = "Name of the SSM managed instance profile"
  type        = string
}
 
variable "ec2_service_principal" {
  description = "Service principal for EC2 role assumption"
  type        = string
}
 
variable "ssm_managed_instance_policy_arn" {
  description = "ARN of the SSM Managed Instance Policy"
  type        = string
}
 