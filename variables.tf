variable "vpc_cidr" {
    type = string
  description = "please provide vpc cidr"
}

variable "project_name" {
  type = "string"
}
variable "environment" {
  type = string
}

variable "vpc_tags" {
  type = map
  default = {}   # it makes optional to provide vpc tags
}

variable "ig_tags" {
  type = map
  default = {}
}

variable "public_subnet_cidrs" {
  type = map
}

variable "public_subnet_tags" {
  type = map
  default = {}
}

variable "private_subnet_cidrs" {
  type = map
  
}

variable "private_subnet_tags" {
  type = map
  default = {}
}