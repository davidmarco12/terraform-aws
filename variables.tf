variable "vpc_cidr" {
  description = "Value of the CIDR range of the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "vpc_name" {
  description = "Value of the name of the VPC"
  type        = string
  default     = "MyVPC"
}

variable "subnet_cidr" {
  description = "Value of the subnet cidr for the VPC"
  type        = string
  default     = "10.0.0.0/24"
}

variable "subnet_name" {
  description = "Value of the subnet name for the VPC"
  type        = string
  default     = "MySubnet"
}

variable "igw_name" {
  description = "Value of the Internet Gateway for the VPC"
  type        = string
  default     = "MyIGW"
}

variable "ec2_ami" {
  description = "Value of the AMI Id for the EC2 Instance"
  type        = string
  default     = "ami-007868005aea67c54"
}

variable "ec2_name" {
  description = "Value of the Name for the EC2 Instance"
  type        = string
  default     = "MyEC2"
}


