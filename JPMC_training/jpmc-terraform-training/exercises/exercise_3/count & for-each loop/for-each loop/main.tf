# Deploy two instances of the terraform module creating an EC2 using a for-each loop

provider "aws" {
  region = "us-west-2"
}

# Map of EC2 instances with different names and instance types
locals {
  instances = {
    "instance-1" = {
      ami           = "ami-0d16a00c70ee279b8" # Replace with a valid AMI ID
      instance_type = "t2.micro"
    },
    "instance-2" = {
      ami           = "ami-0d16a00c70ee279b8" # Replace with a valid AMI ID
      instance_type = "t2.small"
    }
  }
}

resource "aws_instance" "example" {
  for_each      = local.instances # Iterate over the instances map
  ami           = each.value.ami  # Access values in the map
  instance_type = each.value.instance_type
  key_name      = "SSH_kp" # Replace with your key pair

  tags = {
    Name = each.key # Use the key as the name (e.g., instance-a, instance-b)
  }
}

output "instance_ids" {
  value = { for k, v in aws_instance.example : k => v.id } # Output instance IDs with names
}




