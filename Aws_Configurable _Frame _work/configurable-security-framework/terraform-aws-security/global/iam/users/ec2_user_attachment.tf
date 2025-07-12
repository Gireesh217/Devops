

# First, verify that the users exist before attempting to attach policies
data "aws_iam_user" "verify_users" {
  for_each = {
    for user in var.iam_users :
    user.name => user
    if user.enable == true
  }
  
  user_name = each.key
}
 
resource "aws_iam_user_policy_attachment" "user_policy_attachment" {
  for_each = data.aws_iam_user.verify_users
  
  user       = each.key
  policy_arn = var.ec2_launch_with_ssm_policy_arn
}
 