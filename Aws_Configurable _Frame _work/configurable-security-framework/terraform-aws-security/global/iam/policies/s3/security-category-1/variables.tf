variable "iam_s3_modification_deletion" {
  description = "Name of the SSM managed instance policy"
  type        = string
}
 
 variable "aws_region" {
   description = "region"
   type = string
 }

 variable "child_profile" {
    type = string
   description = "profile"
 }

 variable "aws_iam_role" {
   type = string

 }