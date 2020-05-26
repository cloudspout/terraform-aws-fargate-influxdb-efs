data "aws_availability_zones" "available" {
  blacklisted_names = [
    "us-east-1a",
    "us-east-1b",
    //   "us-east-1c",
    "us-east-1d",
    //    "us-east-1e",
    "us-east-1f"
  ]
}

resource "aws_vpc" "_" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = merge(local.common_tags, {
    Name = "Example-${terraform.workspace}-VPC"
  })
}

resource "aws_internet_gateway" "_" {
  vpc_id = aws_vpc._.id
  tags = merge(local.common_tags, {
    Name = "Example-${terraform.workspace}-IGW"
  })
}

resource "aws_subnet" "_" {
  count = length(data.aws_availability_zones.available.names)

  vpc_id                  = aws_vpc._.id
  cidr_block              = "10.0.${count.index}.0/24"
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true
  tags = merge(local.common_tags, {
    Name       = "Example-${terraform.workspace}-Public-${data.aws_availability_zones.available.names[count.index]}"
    Visibility = "public"
  })
}

resource "aws_route_table" "_" {
  count = length(data.aws_availability_zones.available.names)

  vpc_id = aws_vpc._.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway._.id
  }

  tags = merge(local.common_tags, {
    Name = "Example-${terraform.workspace}-Public-${data.aws_availability_zones.available.names[count.index]}"
  })
}

resource "aws_route_table_association" "_" {
  count = length(data.aws_availability_zones.available.names)

  subnet_id      = aws_subnet._[count.index].id
  route_table_id = aws_route_table._[count.index].id
}