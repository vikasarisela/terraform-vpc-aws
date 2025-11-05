resource "aws_vpc" "main" {
  cidr_block       =  var.vpc_cidr
  instance_tenancy = "default"
  enable_dns_hostnames = true

  tags = merge(
    local.common_tags,
    var.vpc_tags,
    {
        Name = local.common_name_suffix
    }
  )
  }

#IGW - attach IGW to vpc id 
  resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    local.common_tags,
    var.ig_tags,
    {
        Name = local.common_name_suffix
    }
  )
}

#public subnet
resource "aws_subnet" "public" {
  count = length(var.public_subnet_cidrs)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.public_subnet_cidrs[count.index]
  availability_zone = local.az_names[count.index]
  map_public_ip_on_launch = true

 tags = merge(
    local.common_tags,
    var.public_subnet_tags,
    {
        Name = "${local.common_name_suffix}-public-${local.az_names[count.index]}"
    }
  )
}

# private subnet creation in az
resource "aws_subnet" "private" {
  count = length(var.private_subnet_cidrs)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.private_subnet_cidrs[count.index]
  availability_zone = local.az_names[count.index]
  

 tags = merge(
    local.common_tags,
    var.private_subnet_tags,
    {
        Name = "${local.common_name_suffix}-private-${local.az_names[count.index]}"
    }
  )
}


resource "aws_subnet" "database" {
  count = length(var.database_subnet_cidrs)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.database_subnet_cidrs[count.index]
  availability_zone = local.az_names[count.index]
  

 tags = merge(
    local.common_tags,
    var.database_subnet_tags,
    {
        Name = "${local.common_name_suffix}-database-${local.az_names[count.index]}"
    }
  )
}

# Route Tables
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

tags = merge(
    local.common_tags,
    var.private_route_table_tags,
    {
        Name = "${local.common_name_suffix}-public"
    }
  )

}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

tags = merge(
    local.common_tags,
    var.private_route_table_tags,
    {
        Name = "${local.common_name_suffix}-private"
    }
  )
  
}

resource "aws_route_table" "database" {
  vpc_id = aws_vpc.main.id

tags = merge(
    local.common_tags,
    var.database_route_table_tags,
    {
        Name = "${local.common_name_suffix}-database"
    }
  )
  
}

# Public Route
resource "aws_route" "public" {
  route_table_id = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"   #Destination
  gateway_id = aws_internet_gateway.main.id    #target
  
}

#EIP
resource "aws_eip" "nat" {
  domain   = "vpc"

  tags = merge(
    local.common_tags,
    var.eip_tags,
    {
        Name = "${local.common_name_suffix}-eip"
    }
  )
}

#NAT Gateway
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id           #attach eip to nat gateway
  subnet_id     = aws_subnet.public[0].id       #us-east-1a  NAT should be in public so created in public[0]

 tags = merge(
    local.common_tags,
    var.nat_tags,
    {
        Name = "${local.common_name_suffix}-nat"
    }
  )

  depends_on = [ aws_internet_gateway.main ]
}

#Private egress route through NAT
resource "aws_route" "private" {
  route_table_id            = aws_route_table.private.id  
  destination_cidr_block    = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.nat.id
}
#Database egress route through NAT
resource "aws_route" "database" {
  route_table_id            = aws_route_table.database.id
  destination_cidr_block    = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.nat.id
}


resource "aws_route_table_association" "public" {
  count = length(var.public_route_table_tags)
  subnet_id      = aws_subnet.public[count.index].id    #referenceing attributes using [*].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  count = length(var.private_route_table_tags)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "database" {
  count = length(var.database_subnet_cidrs)
  subnet_id      = aws_subnet.database[count.index].id
  route_table_id = aws_route_table.database.id
}