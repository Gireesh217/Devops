#  An organization policy that disables serial port access on the virtual machines (EC2)

resource "aws_organizations_policy" "disable_serial_port_access" {
  name        = "DenyEC2SerialPortAccess"
  description = "Deny serial port access on EC2 instances"
  content = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Deny"
        Action   = "ec2:ModifyInstanceAttribute"
        Resource = "*"
        Condition = {
          StringEquals = {
            "ec2:SerialConsoleAccess" = "true"
          }
        }
      }
    ]
  })
  type = "SERVICE_CONTROL_POLICY"
}
resource "aws_organizations_policy_attachment" "attach_ec2_public_ip_policy" {
  policy_id = aws_organizations_policy.ec2_public_ip_policy.id
  target_id = "420366434163" # Replace with your organizational unit ID
}


