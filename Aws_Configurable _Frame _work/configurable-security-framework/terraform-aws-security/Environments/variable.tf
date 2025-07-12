variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
}
 
variable "root_profile" {
  description = "AWS profile for root account"
  type        = string
}
 
variable "child_profile" {
  description = "AWS profile for child account"
  type        = string
}
 
variable "scp_policy_config" {
  description = "Configuration for Service Control Policy"
  type = object({
    name         = string
    description  = string
    instance_profile = string
    root_account = object({
      id = string
    })
    keypair_policy_description =string
    keypair_policy_name = string
    region_policy_name = string
    region_policy_description =string
    restricted_regions = string
    ec2_instance_arns = list(string)
    deny_stop_scp_name = string
    deny_stop_scp_description = string 
    
    instnace_type_name = string
    instance_type = string
    instance_description =string

  })
}


variable "target_accounts" {
  description = "Map of target accounts to attach the policy to"
  type = map(object({
    id      = string
    enabled = bool
  }))
}
 
variable "iam_config" {
  description = "IAM configuration object"
  type = object({
    ssm_policy = object({
      name        = string
      description = string
    })
    ec2_launch_policy = object({
      name        = string
      description = string
    })
    role = object({
      name               = string
      instance_profile   = string
      service_principal  = string
    })
    users = list(object({
      name   = string
      enable = bool
    })
    )
      aws_region = string
    child_profile = string
    
  })  
}
 variable "iam_s3_modification_deletion" {
  description = "Name of the SSM managed instance policy"
  type        = string
}
 
  variable "aws_iam_role" {
   type = string

 }

variable "DenyS3BucketModifications_Name" {
  description = "SCP Policy for Modification and Deletion of S3 Bucket at Organisation Level"
  type = string
}

variable "eks_deny_iam_policy_name" {
  description = "SCP Policy to deny required IAM actions for EKS"
  type = string
}

