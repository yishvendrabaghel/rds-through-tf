# Creating VPC
resource "aws_vpc" "demovpc" {
  cidr_block = var.CIDR_block
  instance_tenancy = "default"
  tags = {
    Name = var.name
  }
}
data "aws_availability_zones" "azs" {
  
}
# Creating Public Subnet for EC2 instance
resource "aws_subnet" "public-subnet" {
  count = var.subnets-you-want
  vpc_id = "${aws_vpc.demovpc.id}"
  cidr_block = "10.0.${count.index}.0/24"
  # cidr_block = var.public-cidr
  availability_zone = data.aws_availability_zones.azs.names[count.index]
  map_public_ip_on_launch = true
  tags = {
    Name = "public-subnet"
  }
}

# Creating Private Subnet for EC2 instance
resource "aws_subnet" "private-subnet" {
  count = var.subnets-you-want
  vpc_id = "${aws_vpc.demovpc.id}"
  # cidr_block = var.private-cidr
  cidr_block = "10.0.${127+count.index}.0/24"
  availability_zone = data.aws_availability_zones.azs.names[count.index]
  # availability_zone = var.availability_zone
  tags = {
    Name = "private-subnet"
  }
}

# Creating Internet Gateway
resource "aws_internet_gateway" "demogateway" {
  vpc_id = "${aws_vpc.demovpc.id}"

}
resource "aws_eip" "nat_gateway_eip" {
  domain = "vpc"
}


#NAT gateway for pvt-subnet
resource "aws_nat_gateway" "yishuNAT" {
  # connectivity_type = "public"
  allocation_id = aws_eip.nat_gateway_eip.id
  # subnet_id         = aws_subnet.private-subnet.id
  subnet_id = aws_subnet.public-subnet[0].id
}


#route table

resource "aws_route_table" "pub-rt" {
  vpc_id = "${aws_vpc.demovpc.id}"

  route{
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.demogateway.id}"
  }
}

resource "aws_route_table" "pvt-rt" {
  vpc_id = "${aws_vpc.demovpc.id}"
  route{
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_nat_gateway.yishuNAT.id}"
  }
}

resource "aws_route_table_association" "pub" {
  subnet_id = "${aws_subnet.public-subnet[0].id}"
  route_table_id = "${aws_route_table.pub-rt.id}"
}

resource "aws_route_table_association" "pvt" {
  subnet_id = "${aws_subnet.private-subnet[0].id}"
  route_table_id = "${aws_route_table.pvt-rt.id}"
}

