resource "aws_organizations_policy" "prevent_ec2_creation_in_regions" {
  name        = var.region_policy_name
  description = var.region_policy_description
  type        = "SERVICE_CONTROL_POLICY"
  content     = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Deny"
        Action   = "ec2:RunInstances"
        Resource = "*"
        Condition = {
          StringEquals = {
            "aws:RequestedRegion" = var.restricted_regions
          }
        }
      }
    ]
  })
}

resource "aws_organizations_policy_attachment" "attach_to_targetid" {
  for_each = { 
    for k, v in var.target_accounts : k => v 
    if v.enabled 
  }
  
  policy_id = aws_organizations_policy.prevent_ec2_creation_in_regions.id
  target_id = each.value.id
}