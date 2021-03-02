resource "aws_vpc" "terraformfile" {
  cidr_block       = "172.16.0.0/16"
  enable_dns_hostnames = true
  tags = {
    Name                   = ""
    owner                  = ""
    environment            = "dev"
  }

}

resource "aws_subnet" "public-subnet_1" {
  vpc_id     = "${aws_vpc.terraformfile.id}"
  cidr_block = "172.16.10.0/24"
  map_public_ip_on_launch = "true"
  availability_zone = "us-east-1a"
  tags = {
    Name                   = ""
    owner                  = ""
    environment            = "dev"
  }

}

resource "aws_internet_gateway" "my-gw" {
   vpc_id = "${aws_vpc.terraformfile.id}"
   tags = {
    Name                   = ""
    owner                  = ""
    environment            = "dev"
  }

   depends_on = ["aws_vpc.terraformfile","aws_internet_gateway.my-gw"]
}

resource "aws_route_table" "main-route" {
   vpc_id = "${aws_vpc.terraformfile.id}"
   route {
       cidr_block = "0.0.0.0/0"
       gateway_id = "${aws_internet_gateway.my-gw.id}"
   }
   tags = {
    Name                   = ""
    owner                  = ""
    environment            = "dev"
  }

   depends_on = ["aws_vpc.terraformfile","aws_internet_gateway.my-gw"]
}
resource "aws_route_table_association" "public-subnet_1-a" {
   subnet_id      = "${aws_subnet.public-subnet_1.id}"
   route_table_id = "${aws_route_table.main-route.id}"
}

