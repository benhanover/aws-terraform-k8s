resource "aws_vpc" "main" {
  cidr_block           = local.vpc_cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "${var.env}-${local.vpc_name}"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${local.vpc_name}-igw"
  }
}

resource "aws_subnet" "private_zone1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = local.private_zone1_cidr_block
  availability_zone = var.zone1

  tags = {
    Name = "${var.env}-${local.vpc_name}-private-1"
  }
}

resource "aws_subnet" "private_zone2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = local.private_zone2_cidr_block
  availability_zone = var.zone2

  tags = {
    Name = "${var.env}-${local.vpc_name}-private-2"
  }
}

resource "aws_subnet" "public_zone1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = local.public_zone1_cidr_block
  availability_zone = var.zone1

  tags = {
    Name = "${var.env}-${local.vpc_name}-public-1"
  }

}

resource "aws_subnet" "public_zone2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = local.public_zone2_cidr_block
  availability_zone = var.zone2

  tags = {
    Name = "${var.env}-${local.vpc_name}-public-2"
  }

}

resource "aws_eip" "nat" {
  domain = "vpc"
  tags = {
    Name = "${var.env}-${local.vpc_name}-nat"
  }

}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public_zone1.id

  tags = {
    Name = "${var.env}-${local.vpc_name}-nat"
  }

  depends_on = [aws_internet_gateway.igw]
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = "${var.env}-${local.vpc_name}-private"
  }

}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.env}-${local.vpc_name}-public"
  }
}


resource "aws_route_table_association" "private_zone1" {
  subnet_id      = aws_subnet.private_zone1.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_zone2" {
  subnet_id      = aws_subnet.private_zone2.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "public_zone1" {
  subnet_id      = aws_subnet.public_zone1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_zone2" {
  subnet_id      = aws_subnet.public_zone2.id
  route_table_id = aws_route_table.public.id
}

resource "aws_network_acl_association" "public1" {
  network_acl_id = var.public_nacl_id
  subnet_id      = aws_subnet.public_zone1.id
}

resource "aws_network_acl_association" "public2" {
  network_acl_id = var.public_nacl_id
  subnet_id      = aws_subnet.public_zone2.id
}

resource "aws_network_acl_association" "private1" {
  network_acl_id = var.private_nacl_id
  subnet_id      = aws_subnet.private_zone1.id
}

resource "aws_network_acl_association" "private2" {
  network_acl_id = var.private_nacl_id
  subnet_id      = aws_subnet.private_zone2.id

}
