# for pipeline test

provider "aws" {
  region = "eu-west-1" # Replace with your region
}

resource "aws_s3_bucket" "test" {
  bucket = "my-bucket-store8019" # Replace with your bucket's name

}