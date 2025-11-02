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
  resource "aws_internet_gateway" "gw" {
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
  vpc_id     = aws_vpc.public.id
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

# private subnet
resource "aws_subnet" "private" {
  count = length(var.private_subnet_cidrs)
  vpc_id     = aws_vpc.public.id
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
  vpc_id     = aws_vpc.public.id
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


