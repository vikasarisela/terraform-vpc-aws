variable "vpc_cidr" {
    type = string
  description = "please provide vpc cidr"
}

variable "project_name" {
  type = string
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
variable "nat_tags" {
  type = map
  default = {}
}
variable "eip_tags" {
  type = map
  default = {}
}

variable "public_subnet_tags" {
  type = map
  default = {}
}
  variable "private_subnet_tags" {
  type = map
  default = {}
}

  variable "database_subnet_tags" {
  type = map
  default = {}
}

variable "public_route_table_tags" {
  type = map
  default = {}
}

variable "private_route_table_tags" {
  type = map
  default = {}
}
# variable "public_subnet_cidrs_module" {
#   type = list
# }

# variable "private_subnet_cidrs_module" {
#   type = list
# }

# variable "database_subnet_cidrs_module" {
#   type = list
# }

variable "public_subnet_cidrs" {
  type = map
}

variable "private_subnet_cidrs" {
  type = map
  
}

variable "database_subnet_cidrs" {
  type = map
}