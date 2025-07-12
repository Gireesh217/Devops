terraform {
  backend "s3" {
    bucket         = "my-bucket-stroage1234"
    key            = "terraform.tfstate"
    region         = "us-west-2"
    dynamodb_table = "terraform-tabledev123"
  }
}
 