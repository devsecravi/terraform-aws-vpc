resource "aws_vpc" "main" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"
  enable_dns_hostnames= true

  tags = local.vpc2_final_tags
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags =local.igw_final_tags
}

resource "aws_subnet" "public" {
   count = length(var.public_subnet_cird)
   vpc_id     = aws_vpc.main.id
   cidr_block = var.public_subnet_cird[count.index]
   availability_zone = local.az_names[count.index]
   map_public_ip_on_launch = true
    tags =  merge(
          local.common_tags,
          {
             Name = "${var.project}-${var.environment}-public-${local.az_names[count.index]}"
          },
          var.public_subnet_tags
    )
}

resource "aws_subnet" "private" {
   count = length(var.private_subnet_cird)
   vpc_id     = aws_vpc.main.id
   cidr_block = var.private_subnet_cird[count.index]
   availability_zone = local.az_names[count.index]
   map_public_ip_on_launch = true
    tags =  merge(
          local.common_tags,
          {
             Name = "${var.project}-${var.environment}-private-${local.az_names[count.index]}"
          },
          var.private_subnet_tags
    )
}

resource "aws_subnet" "database" {
   count = length(var.database_subnet_cird)
   vpc_id     = aws_vpc.main.id
   cidr_block = var.database_subnet_cird[count.index]
   availability_zone = local.az_names[count.index]
   map_public_ip_on_launch = true
    tags =  merge(
          local.common_tags,
          {
             Name = "${var.project}-${var.environment}-database-${local.az_names[count.index]}"
          },
          var.database_subnet_tags
    )
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = merge(
          local.common_tags,
          {
             Name = "${var.project}-${var.environment}-public"
          },
          var.public_route_table_tags
    )
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  tags = merge(
          local.common_tags,
          {
             Name = "${var.project}-${var.environment}-private"
          },
          var.private_route_table_tags
    )
}

resource "aws_route_table" "database" {
  vpc_id = aws_vpc.main.id

  tags = merge(
          local.common_tags,
          {
             Name = "${var.project}-${var.environment}-database"
          },
          var.database_route_table_tags
    )
}

resource "aws_route" "public" {
  route_table_id            = aws_route_table.public.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id= aws_internet_gateway.main.id
}

resource "aws_eip" "nat" {

     domain = "vpc"
     tags = merge(
          local.common_tags,
          {
             Name = "${var.project}-${var.environment}-nat"
          },
          var.eip_nat_tags
    )
}

resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[0].id

  tags = merge(
          local.common_tags,
          {
             Name = "${var.project}-${var.environment}"
          },
          var.nat_gateway_tags
    )

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.main]
}

resource "aws_route" "private" {
  route_table_id            = aws_route_table.public.id
  destination_cidr_block    = "0.0.0.0/0"
  nat_gateway_id= aws_nat_gateway.main.id
}

resource "aws_route" "database" {
  route_table_id            = aws_route_table.public.id
  destination_cidr_block    = "0.0.0.0/0"
  nat_gateway_id= aws_nat_gateway.main.id
}

resource "aws_route_table_association" "public"{
      count = lenght(var.public_subnet_cird)
      subnet_id = aws_subnet.public[count.index].id
      route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private"{
      count = lenght(var.private_subnet_cird)
       subnet_id = aws_subnet.private[count.index].id
       route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "database"{
      count = lenght(var.database_subnet_cird)
       subnet_id = aws_subnet.database[count.index].id
       route_table_id = aws_route_table.database.id
}


