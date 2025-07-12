#  Create an S3 bucket via the console and import this into state file through the terraform configuration

provider "aws" {
  region = "eu-west-1" # Replace with your region
}

resource "aws_s3_bucket" "test" {
  bucket = "my-bucket-store321" # Replace with your bucket's name

}

#terraform import aws_s3_bucket.example my-bucket-store321