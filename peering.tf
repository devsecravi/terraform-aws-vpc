resource "aws_vpc_peering_connection" "foo" {
  count = var.is_peering ? 1 : 0

  #accepter
  peer_vpc_id   = data.aws_vpc.default.id

  #requester
  vpc_id        = aws_vpc.main.id

  accepter {
    allow_remote_vpc_dns_resolution = true
  }

  requester {
    allow_remote_vpc_dns_resolution = true
  }

  tags = merge(
       local.common_tags,
       {
          Name= "${var.project}-${var.environment}-default"
       }
  )
}

resource "aws_route" "public-peering" {
   count = var.is_peering ? 1 : 0
  route_table_id            = aws_route_table.public.id
  destination_cidr_block    = data.aws_vpc.default.cidr_block
  vpc_peering_connection_id= aws_vpc_peering_connection.default[count.index].id
}

resource "aws_route" "private-peering" {
   count = var.is_peering ? 1 : 0
  route_table_id            = aws_route_table.private.id
  destination_cidr_block    = data.aws_vpc.default.cidr_block
  vpc_peering_connection_id= aws_vpc_peering_connection.default[count.index].id
}

resource "aws_route" "database-peering" {
   count = var.is_peering ? 1 : 0
  route_table_id            = aws_route_table.database.id
  destination_cidr_block    = data.aws_vpc.default.cidr_block
  vpc_peering_connection_id= aws_vpc_peering_connection.default[count.index].id
}

resource "aws_route" "default-peering" {
   count = var.is_peering ? 1 : 0
  route_table_id            = data.aws_route_table.default.id
  destination_cidr_block    = var.vpc_cidr
  vpc_peering_connection_id= aws_vpc_peering_connection.default[count.index].id
}