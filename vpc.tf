resource "aws_vpc" "MIKE-VPC" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "MIKE-VPC"
  }
}


resource "aws_subnet" "mike-public-subnet" {
  vpc_id     = aws_vpc.MIKE-VPC.id
  cidr_block = "10.0.24.0/24"

  tags = {
    Name = "Mike-pub-sub"
  }
}


resource "aws_subnet" "mike-private-subnet" {
  vpc_id     = aws_vpc.MIKE-VPC.id
  cidr_block = "10.0.25.0/24"

  tags = {
    Name = "Mike-pri-sub"
  }
}

resource "aws_route_table" "mike-public-route" {
  vpc_id  = aws_vpc.MIKE-VPC.id
  tags    = {
    Name  ="public-route-table"
  }
}

resource "aws_route_table" "mike-private-route" {
  vpc_id  = aws_vpc.MIKE-VPC.id
  tags    = {
    Name  ="private-route-table"
  }
}

# mike public sub association
resource "aws_route_table_association" "mike-public-route-association" {
  subnet_id      = aws_subnet.mike-public-subnet.id
  route_table_id = aws_route_table.mike-public-route.id
}

# mike private sub association
resource "aws_route_table_association" "mike-private-route-association" {
  subnet_id      = aws_subnet.mike-private-subnet.id
  route_table_id = aws_route_table.mike-private-route.id
}

# mike igw
resource "aws_internet_gateway" "mike-igw" {
   vpc_id = aws_vpc.MIKE-VPC.id

   tags = {
    Name = "mike-igw"
   }
}

# mike igw route

resource "aws_route" "mike-route" {
  route_table_id            = aws_route_table.mike-public-route.id
  gateway_id                = aws_internet_gateway.mike-igw.id
  destination_cidr_block    = "0.0.0.0/0"
}
