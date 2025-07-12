resource "aws_organizations_policy" "deny_stop_terminate_ec2" {
  name        = var.deny_stop_scp_name
  description = var.deny_stop_scp_description
  type        = "SERVICE_CONTROL_POLICY"
  content     = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        Effect   = "Deny"
        Action   = [
          "ec2:StopInstances",
          "ec2:TerminateInstances"
        ]
        Resource = var.ec2_instance_arns
      }
    ]
  })
}

resource "aws_organizations_policy_attachment" "scp_attachment_to_ou" {
  for_each = { 
    for k, v in var.target_accounts : k => v 
    if v.enabled 
  }
  
  policy_id = aws_organizations_policy.deny_stop_terminate_ec2.id
  target_id = each.value.id
}