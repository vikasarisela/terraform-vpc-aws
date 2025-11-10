# resource "aws_vpc_peering_connection" "default" { 
#   count =  var.is_peering_required ? 1 : 0
 
#   peer_vpc_id   = data.aws_vpc.default.id  #acceptor  default
#   vpc_id        = aws_vpc.main.id           # roboshop

#   accepter {
#     allow_remote_vpc_dns_resolution = true
#   }

#   requester {
#     allow_remote_vpc_dns_resolution = true
#   }

#   auto_accept = true          # same account works

#   tags = merge(
#     local.common_tags,
#     var.ig_tags,
#     {
#         Name = "${local.common_name_suffix}-default"
#     }
#   )
# }

# resource "aws_route" "public_peering" {
#     count =  var.is_peering_required ? 1 : 0
#   route_table_id            = aws_route_table.public.id
#   destination_cidr_block    = data.aws_vpc.default.cidr_block
#   vpc_peering_connection_id = aws_vpc_peering_connection.default.id
# }