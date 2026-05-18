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

resource "aws_subnet" "public_us_east_1a" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"

  tags =  local.sb_fina_tags
}

resource "aws_subnet" "public_us_east_1b" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.2.0/24"

  tags = local.sb_fina_tags
}

