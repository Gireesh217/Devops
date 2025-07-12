provider "aws" {
  region =  var.aws_region
  profile = var.root_profile
}

resource "aws_organizations_policy" "eks-iam-restrictions" {
  name = var.eks_deny_iam_policy_name
  type = "SERVICE_CONTROL_POLICY"
  content = jsonencode({
    Version = "2012-10-17"
    Statement = [
      # Allow specific IAM actions necessary for EKS management
      {
        Sid     = "AllowEKSRequiredIAMActions"
        Effect  = "Allow"
        Action  = [
          "iam:PassRole", 
          "iam:CreateServiceLinkedRole", 
          "iam:GetRole",
          "iam:ListAttachedRolePolicies", 
          "iam:AttachRolePolicy", 
          "iam:DetachRolePolicy", 
          "iam:CreateRole", 
          "iam:DeleteRole", 
          "iam:UpdateRole", 
          "iam:PutRolePolicy", 
          "iam:DeleteRolePolicy",
          "iam:ListPolicies",           # Allow listing IAM policies
          "iam:ListRoles",              # Allow listing IAM roles
          "iam:GetPolicy",              # Allow getting IAM policy details
          "iam:ListAttachedRolePolicies", # Allow listing attached policies for a role
          "iam:AttachRolePolicy",
          "iam:PutUserPolicy",
          "iam:PutRolePolicy"
        ]
        Resource = "*"
      },

      # Allow necessary EKS permissions for cluster and node group management
      {
        Sid     = "AllowEKSClusterManagement"
        Effect  = "Allow"
        Action  = [
          "eks:CreateCluster",
          "eks:DescribeCluster",
          "eks:UpdateClusterConfig",
          "eks:UpdateClusterVersion",
          "eks:CreateNodegroup",
          "eks:DescribeNodegroup",
          "eks:UpdateNodegroupConfig",
          "eks:UpdateNodegroupVersion",
          "eks:ListClusters",
          "eks:ListNodegroups",
          "eks:ListUpdates",
          "eks:TagResource",
          "eks:UntagResource",
          "eks:AccessKubernetesApi",
          "eks:DeleteNodegroup"
        ]
        Resource = "*"
      },

      # Allow EC2 actions for security groups and networking related to EKS
      {
        Sid     = "AllowEC2NetworkingForEKS"
        Effect  = "Allow"
        Action  = [
          "ec2:CreateSecurityGroup",
          "ec2:DescribeSecurityGroups",
          "ec2:AuthorizeSecurityGroupIngress",
          "ec2:RevokeSecurityGroupIngress",
          "ec2:AuthorizeSecurityGroupEgress",
          "ec2:RevokeSecurityGroupEgress",
          "ec2:CreateSecurityGroupEgress",
          "ec2:DescribeInstances",
          "ec2:DescribeSecurityGroups",
          "ec2:DescribeSubnets",
          "ec2:DescribeVpcs"
        ]
        Resource = "*"
      },

      # Allow auto scaling actions for EKS node management
      {
        Sid     = "AllowAutoScalingForEKS"
        Effect  = "Allow"
        Action  = [
          "autoscaling:CreateAutoScalingGroup",
          "autoscaling:UpdateAutoScalingGroup",
          "autoscaling:DescribeAutoScalingGroups",
          "autoscaling:DeleteAutoScalingGroup"
        ]
        Resource = "*"
      },

      # Deny specific IAM actions that are not required for EKS (to ensure least privilege)
      {
        Sid     = "DenyUnnecessaryIAMActions"
        Effect  = "Deny"
        Action  = [
          "iam:DeleteUser", 
          "iam:CreateUser", 
          "iam:DeleteGroup", 
          "iam:CreateGroup", 
          "iam:CreatePolicy", 
          "iam:DeletePolicy",
          "iam:PutGroupPolicy",
          "iam:AttachUserPolicy",
          "iam:AttachGroupPolicy",
          "iam:DetachUserPolicy",
          "iam:DetachGroupPolicy",
          "iam:DetachRolePolicy"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_organizations_policy_attachment" "eks-iam-restrictions-attachment" {
    for_each = { 
        for k, v in var.target_accounts : k => v 
        if v.enabled 
    }

    policy_id = aws_organizations_policy.eks-iam-restrictions.id
    target_id = each.value.id # Target AWS Account or Organizational Unit ID
}
