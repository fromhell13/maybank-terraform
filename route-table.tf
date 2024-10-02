# Route Tables
## Public Route Table
resource "aws_route_table" "public_rt" {
  count = 2
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "192.168.0.0/16"
    gateway_id = "local"
  }

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw[count.index].id
  }
}

resource "aws_route_table_association" "public_association" {
  count          = 2
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public_rt[count.index].id
}

## Private Route Table
resource "aws_route_table" "private_rt" {
  count = 2
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "192.168.0.0/16"
    gateway_id = "local"
  }

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw[count.index].id
  }
}

resource "aws_route_table_association" "private_association" {
  count          = 2
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private_rt[count.index].id
}
