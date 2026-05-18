resource "aws_vpc_peering_connection" "foo" {
  count = length(is_peering) ? 1 : 0

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