# NAT Gateway Elastic IP
resource "aws_eip" "nat" {
  count = 2
  domain = "vpc"
  tags = {
    Name = "nat-gw-eip-az-${data.aws_availability_zones.available.names[count.index]}"
  }
}

# Nat Gateway Public Subnet
resource "aws_nat_gateway" "nat_gw" {
  count = 2
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public[count.index].id

  tags = {
    Name = "nat-gw-az-${data.aws_availability_zones.available.names[count.index]}"
  }

  depends_on = [aws_internet_gateway.igw]
}