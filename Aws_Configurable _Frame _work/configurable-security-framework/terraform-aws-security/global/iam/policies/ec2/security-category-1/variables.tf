variable "ssm_policy_name" {
  description = "Name of the SSM managed instance policy"
  type        = string
}
 
variable "ssm_policy_description" {
  description = "Description of the SSM managed instance policy"
  type        = string
}
 
variable "ec2_launch_policy_name" {
  description = "Name of the EC2 launch with SSM policy"
  type        = string
}
 
variable "ec2_launch_policy_description" {
  description = "Description of the EC2 launch with SSM policy"
  type        = string
}
 
variable "ssm_pass_role_resource" {
  description = "Resource ARN for SSM role pass"
  type        = string
}
 

 variable "aws_region" {
   description = "region"
   type = string
 }

 variable "child_profile" {
   description = "profile"
 }