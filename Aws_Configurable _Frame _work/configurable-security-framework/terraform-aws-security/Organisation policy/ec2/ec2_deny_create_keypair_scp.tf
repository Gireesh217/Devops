# main.tf

resource "aws_organizations_policy" "deny_create_key_pair_scp" {
  name        = var.keypair_policy_name
  description = var.keypair_policy_description
  content     = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Deny",
      "Action": "ec2:CreateKeyPair",
      "Resource": "*"
    }
  ]
}
POLICY
  type = "SERVICE_CONTROL_POLICY"
}

resource "aws_organizations_policy_attachment" "attach_deny_create_key_pair_scp" {
  for_each = {
    for k, v in var.target_accounts : k => v
    if v.enabled
  }
  policy_id = aws_organizations_policy.deny_create_key_pair_scp.id
  target_id = each.value.id
}
