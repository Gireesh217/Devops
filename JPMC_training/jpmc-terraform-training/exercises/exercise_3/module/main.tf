#  Migrate the EC2, VPC and subnets into individual terraform modules defined locally

provider "aws" {
  region = "us-west-2"
}

module "vpc" {
  source              = "./modules/vpc"
  cidr_block          = "10.0.0.0/16"
  subnet_a_cidr       = "10.0.1.0/24"
  subnet_b_cidr       = "10.0.2.0/24"
  availability_zone_a = "us-west-2a"
  availability_zone_b = "us-west-2b"
}

module "compute" {
  source        = "./modules/compute"
  ami_id        = "ami-0d16a00c70ee279b8" # replace with actual AMI ID
  instance_type = "t2.micro"
  subnet_id     = module.vpc.subnet_a_id
  key_name      = "SSH_kp"
  instance_name = "my_ec2"
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "instance_id" {
  value = module.compute.instance_id
}
