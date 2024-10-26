variable "aws_region" {
  type = string
}

variable "aws_vpc_cidr" {
  type = string
}

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "Public Subnet CIDR values"
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "Private Subnet CIDR values"
}

variable "azs" {
  type        = list(string)
  description = "Availability Zones"
}

variable "instance_type" {
  type = string
}

variable "ssh_key" {
  type = string
}

variable "capacity" {
  type = string
}

variable "disk_size" {
  type = number
}
variable "ami_type" {
  type = string
}

variable "cluster_name" {
  type = string
}