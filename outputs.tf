output "vpc_id" {
  value = aws_vpc.main.id
}

# output "subn" {
#   description = "public subnet testing................"
#   value = aws_subnet.public[0].id
# }


# output "public_subnet_ids" {
#   description = "IDs of all public subnets"
#   value       = aws_subnet.public[*].id
# }

# output "test_message" {
#   value = "Terraform output working"
# output "public_subnet_ids" {
#   description = "IDs of all public subnets"
#   value       = module.vpc.aws_subnet.public[*].id
# }



# }
