variable "client_name" {

  type = string

  description = "client name for tags"

}

variable "client_vpc" {

  type = string

  description = "VPC to be used for client"

}

variable "cidr_block" {

  type = string

  description = "cidr block for client"

}

variable "availability_zone" {

  type = string

  description = "AZ for Client"
}

variable "private_ips" {

  type = string

  description = "IP for Server"
}

variable "client_ami" {
  type = string

  default = "ami-09d56f8956ab235b3"

  description = "AMI for server"

}

variable "client_instance_type" {

  type = string

  default = "t2.micro"

  description = "Server instance type for client"

}

variable "key_name" {

  type = string

  default = "main-key"

  description = "Key to be used to access client server via ssh"

}

variable "user_data_template" {
  type = string

  default = "userdata.tpl"

  description = "Template for Instance starting script"
}