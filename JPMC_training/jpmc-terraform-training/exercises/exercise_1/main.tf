# Create a simple AWS VPC and subnet with an EC2 instance include a startup script within the instance copying a local ssh key to the instance.

provider "aws" {
  region = "eu-west-1" # Replace with your desired AWS region
}

# Create a VPC
resource "aws_vpc" "own_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
}

# Create a subnet within the VPC
resource "aws_subnet" "own_sub" {
  vpc_id                  = aws_vpc.own_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "eu-west-1a"
  map_public_ip_on_launch = true
}

# Create a security group to allow SSH access
resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH access"
  vpc_id      = aws_vpc.own_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create an SSH key pair (use the path to your actual public key)
resource "aws_key_pair" "my_key" {
  key_name   = "own_key"
  public_key = file("C:/Users/dabbugunta_g/.ssh/id_rsa.pub") # Update with the correct path
}

# Create an EC2 instance and associate the security group
resource "aws_instance" "my_instance" {
  ami                    = "ami-0e0568f9dc9d55f5d" # Amazon Linux 2 AMI (replace if necessary)
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.own_sub.id
  vpc_security_group_ids = [aws_security_group.allow_ssh.id] # Correct way to reference security group by ID
  key_name               = aws_key_pair.my_key.key_name

  # User data to copy the SSH public key to the instance
  user_data = <<-EOF
              #!/bin/bash
              mkdir -p ~/.ssh
              echo "${file("C:/Users/dabbugunta_g/.ssh/id_rsa.pub")}" > ~/.ssh/authorized_keys
              chmod 600 ~/.ssh/authorized_keys
              EOF

  tags = {
    Name = "ownEC2Instance"
  }
}

