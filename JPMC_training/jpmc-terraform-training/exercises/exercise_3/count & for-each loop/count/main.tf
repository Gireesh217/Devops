#  - Deploy two instances of the terraform module creating an EC2 using a count

provider "aws" {
  region = "us-west-2"
}

resource "aws_instance" "us" {
  count         = 2                       # Deploying 2 EC2 instances
  ami           = "ami-0d16a00c70ee279b8" # Replace with a valid AMI ID
  instance_type = "t2.micro"
  key_name      = "SSH_kp" # Replace with your key pair

  tags = {
    Name = "usa-${count.index}" # Unique tag based on index
  }
}

output "instance_ids" {
  value = aws_instance.us[*].id # Output the instance IDs of both instances
}
