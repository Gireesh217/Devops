
resource "aws_organizations_policy" "require_specific_ec2_iam_profile" {
  name        = var.policy_name
  description = var.policy_description
  
  content = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowSpecificInstanceProfile"
        Effect = "Deny"
        Action = ["ec2:RunInstances"]
        Resource = ["arn:aws:ec2:*:*:instance/*"]
        Condition = {
          "ForAllValues:StringNotLike" = {
            "ec2:InstanceProfile" = [
               "*${var.allowed_instance_profiles}",
              "*${var.allowed_instance_profiles}*" 
            ]
          }
        }
      }
    ]
  })
}
 
resource "aws_organizations_policy_attachment" "attach_to_targets" {
  for_each = { 
    for k, v in var.target_accounts : k => v 
    if v.enabled 
  }
  
  policy_id = aws_organizations_policy.require_specific_ec2_iam_profile.id
  target_id = each.value.id
}
 