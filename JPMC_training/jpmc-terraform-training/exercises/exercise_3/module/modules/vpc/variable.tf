variable "cidr_block" {
  description = "10.0.0.0/16"
  type        = string
}

variable "subnet_a_cidr" {
  description = "10.0.1.0/24"
  type        = string
}

variable "subnet_b_cidr" {
  description = "10.0.2.0/24"
  type        = string
}

variable "availability_zone_a" {
  description = "us-west-2a"
  type        = string
}

variable "availability_zone_b" {
  description = "us-west-2b"
  type        = string
}
