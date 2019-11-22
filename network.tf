resource "aws_vpc" "myVPC1" {
  cidr_block = "10.10.10.0/27"
  tags = {
    Name = "myvpc"
 }
}
resource "aws_subnet" "publicsubnet" {
  vpc_id= "${aws_vpc.myVPC1.id}"
  cidr_block = "10.10.10.0/28"
  map_public_ip_on_launch = true
  depends_on=[aws_vpc.myVPC1]

  tags = {
    Name = "pub_sub"
  }
}
resource "aws_subnet" "privatesubnet" {
  vpc_id= "${aws_vpc.myVPC1.id}"
  cidr_block = "10.10.10.16/28"
  map_public_ip_on_launch = false
  depends_on=[aws_vpc.myVPC1]

  tags = {
    Name = "prv_sub"
  }
}
resource "aws_internet_gateway" "mgw" {
  vpc_id = "${aws_vpc.myVPC1.id}"
  depends_on=[aws_vpc.myVPC1]

  tags = {
    Name = "myigw"
  }
}
resource "aws_route_table" "routPUB" {
  vpc_id ="${aws_vpc.myVPC1.id}"
  depends_on=[aws_vpc.myVPC1,aws_internet_gateway.mgw]
  
  route {
    cidr_block = "0.0.0.0/0"
   gateway_id=aws_internet_gateway.mgw.id

 }
   tags = {
      Name="mypubrt"
 }
}

resource "aws_route_table_association" "a" {
