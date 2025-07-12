#  A service control policy (scp) that prevents EC2 instances from being assigned a public ip address

resource "aws_organizations_policy" "ec2_public_ip_policy" {
  name        = "DenyaccessForEC2"
  description = "Prevents EC2 instances from being assigned public IPs"
  type        = "SERVICE_CONTROL_POLICY"

  content = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Deny",
        "Action": "ec2:RunInstances",
        "Resource": "*",
        "Condition": {
          "StringEquals": {
            "ec2:AssociatePublicIpAddress": "true"
          }
        }
      }
    ]
}
EOF
}

resource "aws_organizations_policy_attachment" "attach_ec2_public_ip_policy" {
  policy_id = aws_organizations_policy.ec2_public_ip_policy.id
  target_id = "420366434163" # Replace with your organizational unit ID
}





 