data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_vpc" "default" {    #default vpc id   it is to get the existing information 
  default = true
}

