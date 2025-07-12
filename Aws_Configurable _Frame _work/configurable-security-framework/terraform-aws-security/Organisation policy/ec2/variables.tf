variable "policy_name" {
  description = "Name of the organization policy"
  type        = string
}
 
variable "policy_description" {
  description = "Description of the organization policy"
  type        = string
}
 
variable "target_accounts" {
  description = "Map of target accounts to attach the policy to"
  type = map(object({
    id      = string
    enabled = bool
  }))
}
 
variable "root_account_id" {
  description = "ID of the root account"
  type        = string
}
 
variable "aws_region" {
    description = "region"
    type = string
}

variable "root_profile" {
  description = "profile"
  type = string
}
variable "allowed_instance_profiles" {
  description = "iam instance profile"
  type = string
}

variable "keypair_policy_name" {
description = "Policy name"  
type = string
}

variable "keypair_policy_description" {
  description = "description of policy"
  type = string
}

variable "region_policy_name" {
  description = "policy name"
  type = string
}

variable "region_policy_description" {
  description = "policy descripion"
  type = string
}

variable "restricted_regions" {
  description = "restricted regions for ec2 creation"
  type = string
}

variable "ec2_instance_arns" {
  description = "The list of EC2 instance ARNs to which stopping or termination is denied."
  type        = list(string)
}

variable "deny_stop_scp_name" {
  description = "The name of the Service Control Policy (SCP)."
  type        = string
  # default     = "DenyStopTerminateEC2"  # Default name for the policy
}

variable "deny_stop_scp_description" {
  description = "The description of the Service Control Policy (SCP)."
  type        = string
  # default     = "This SCP denies stopping or terminating specific EC2 instances."  # Default description
}

variable "instnace_type_name" {
  description = "The name of the AWS Organizations policy"
  type        = string
}

variable "instance_description" {
  description = "A description of the AWS Organizations policy"
  type        = string
}


variable "instance_type" {
  description = "The EC2 instance type to allow"
  type        = string
}