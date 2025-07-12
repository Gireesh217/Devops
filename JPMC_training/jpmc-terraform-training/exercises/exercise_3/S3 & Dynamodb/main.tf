#   implement Dynamo DB for state locking and consistency checking


provider "aws" {
  region = "us-west-2"
}

resource "aws_s3_bucket" "my_bucket" {
  bucket = "my-bucket-stroage1234"
}
resource "aws_s3_bucket_versioning" "name" {
  bucket = aws_s3_bucket.my_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Create a DynamoDB table for state locking
resource "aws_dynamodb_table" "tf_lock_table" {
  name         = "terraform-tabledev123"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}