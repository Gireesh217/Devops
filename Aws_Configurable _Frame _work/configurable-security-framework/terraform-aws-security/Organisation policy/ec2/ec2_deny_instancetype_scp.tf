
resource "aws_organizations_policy" "restrict_ec2_instance_type" {
  name        = var.instnace_type_name
  description = var.instance_description
  type        = "SERVICE_CONTROL_POLICY"
  content     = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        Sid    = "RequireSpecificInstanceType"
        Effect = "Deny"
        Action = "ec2:RunInstances"
        Resource = "arn:aws:ec2:*:*:instance/*"
        Condition = {
          StringNotEquals = {
            "ec2:InstanceType" = var.instance_type
          }
        }
      }
    ]
  })
}


resource "aws_organizations_policy_attachment" "restrict_ec2_instance_type_attachment" {
  for_each = { 
    for k, v in var.target_accounts : k => v 
    if v.enabled 
  }
  
  policy_id = aws_organizations_policy.restrict_ec2_instance_type.id
  target_id = each.value.id
}
