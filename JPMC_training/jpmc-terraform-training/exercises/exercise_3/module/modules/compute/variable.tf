variable "ami_id" {
  description = "ami-0d16a00c70ee279b8"
  type        = string
}

variable "instance_type" {
  description = "t2.micro"
  type        = string
}

variable "subnet_id" {
  description = "10.0.1.0/24"
  type        = string
}

variable "key_name" {
  description = "SSH_kp"
  type        = string
}

variable "instance_name" {
  description = "my_ec2"
  type        = string
}
