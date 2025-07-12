 
terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
    }
  }
}


# Root Account Provider
provider "aws" {
  alias   = "root"
  region  = var.aws_region
  profile = var.root_profile
}
 
# Child Account Provider
provider "aws" {
  region  = var.aws_region
  profile = var.child_profile
}
 
# Organization Policy Module (in root account)

module "organization_policy" {
  source = "../Organisation policy/ec2"
  

  policy_name        = var.scp_policy_config.name
  policy_description = var.scp_policy_config.description
  target_accounts    = var.target_accounts
  root_account_id    = var.scp_policy_config.root_account.id
  aws_region = var.aws_region
  root_profile = var.root_profile
  allowed_instance_profiles = var.scp_policy_config.instance_profile
  keypair_policy_description = var.scp_policy_config.keypair_policy_description
  keypair_policy_name = var.scp_policy_config.keypair_policy_name
  region_policy_name = var.scp_policy_config.region_policy_name
  region_policy_description = var.scp_policy_config.region_policy_description
  restricted_regions = var.scp_policy_config.restricted_regions
  ec2_instance_arns = var.scp_policy_config.ec2_instance_arns
  deny_stop_scp_name = var.scp_policy_config.deny_stop_scp_name
  deny_stop_scp_description = var.scp_policy_config.deny_stop_scp_description
  
  
  instance_description = var.scp_policy_config.instance_description
  instance_type = var.scp_policy_config.instance_type
  instnace_type_name = var.scp_policy_config.instnace_type_name


}
 
# IAM Modules

module "iam_policies" {

#   source = "../../modules/iam/policies/ec2/security-category-1"
  # source = "../../global/iam/policies/ec2/security-category-1"
  source = "../global/iam/policies/ec2/security-category-1"
  ssm_policy_name           = var.iam_config.ssm_policy.name
  ssm_policy_description    = var.iam_config.ssm_policy.description
  ec2_launch_policy_name    = var.iam_config.ec2_launch_policy.name
  ec2_launch_policy_description = var.iam_config.ec2_launch_policy.description
 
  
  # Dynamically construct SSM pass role resource
  ssm_pass_role_resource = "arn:aws:iam::${var.target_accounts.account_1.id}:role/${var.iam_config.role.name}"
    aws_region =  var.iam_config.aws_region
    child_profile = var.iam_config.child_profile
}
 
module "iam_roles" {
  # source = "../../global/iam/roles"
 source = "../global/iam/roles" 
  ssm_role_name             = var.iam_config.role.name
  ssm_instance_profile_name = var.iam_config.role.instance_profile
  ec2_service_principal     = var.iam_config.role.service_principal
  ssm_managed_instance_policy_arn = module.iam_policies.ssm_managed_instance_policy_arn
}
 
module "iam_users" {
  # source = "../../global/iam/users"
  
  # iam_user = var.iam_config.user.name
  # ec2_launch_with_ssm_policy_arn = module.iam_policies.ec2_launch_with_ssm_policy_arn
  source = "../global/iam/users"
   iam_users = var.iam_config.users
  ec2_launch_with_ssm_policy_arn = module.iam_policies.ec2_launch_with_ssm_policy_arn
}

 module "organization_policy_S3" {
  source = "../Organisation policy/s3"
  aws_region = var.aws_region
  target_accounts = var.target_accounts
  DenyS3BucketModifications_Name = var.iam_s3_modification_deletion
  root_profile = var.root_profile
 }
 
 module "aws_iam_policy" {
   source = "../global/iam/policies/s3/security-category-1"
   aws_iam_role = var.aws_iam_role
   child_profile = var.child_profile
   aws_region = var.aws_region
   iam_s3_modification_deletion = var.iam_s3_modification_deletion
 }

 module "organization_policy_eks" {
   source = "../Organisation policy/eks"
   eks_deny_iam_policy_name = var.eks_deny_iam_policy_name
   target_accounts = var.target_accounts
   aws_region = var.aws_region
   root_profile = var.root_profile
 }
