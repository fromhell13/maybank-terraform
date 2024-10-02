# Internet Gateway
resource "aws_internet_gateway" "igw" {
  count = 2
  vpc_id = aws_vpc.my_vpc.id
}