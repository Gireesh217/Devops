resource "aws_iam_role" "ssm_managed_instance_role" {
  name = var.ssm_role_name
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = var.ec2_service_principal
        }
      }
    ]
  })
 
  tags = {
    Name = var.ssm_role_name
  }
}
 
resource "aws_iam_role_policy_attachment" "ssm_managed_instance_attachment" {
  role       = aws_iam_role.ssm_managed_instance_role.name
  policy_arn = var.ssm_managed_instance_policy_arn
}
 
resource "aws_iam_instance_profile" "ssm_managed_instance_profile" {
  name = var.ssm_instance_profile_name
  role = aws_iam_role.ssm_managed_instance_role.name
}
 