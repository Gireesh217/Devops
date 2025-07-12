#  A resource control policy (rcp) that assigns the policy 'AmazonEC2FullAccess' to the EC2 instance previously created

provider "aws" {
  region = "eu-west-1"
}
resource "aws_organizations_policy" "allow_ec2_full_access" {
  name        = "AwsEC2FullAccess"
  description = "Provides Amazon EC2 full access to the EC2 instance"
  type        = "RESOURCE_CONTROL_POLICY"


  content = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [    
    {
      "Sid": "AwsEC2FullAccess",
      "Effect": "Allow",
      "Principal": "*",
      "Action": "*" ,
      "Resource": "*"
    }
  ]
}
EOF
}
resource "aws_organizations_policy_attachment" "account" {
  policy_id = aws_organizations_policy.allow_ec2_full_access.id
  target_id = "420366434163"
}
 