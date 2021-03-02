resource "aws_vpc" "staging-vpc" {
  cidr_block       = "172.16.0.0/16"
  enable_dns_hostnames = true

  tags = {
   Name                   = "staging"
   owner                  = "paritoshik.paul@srijan.net"
   stack                  = "demo"
   environment            = "dev"
  }

}

## Security Group##
resource "aws_security_group" "staging_sg" {
  description = "Allow limited inbound external traffic"
  vpc_id      = "${aws_vpc.staging-vpc.id}"
  name        = "staging_sg"

  ingress {
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 22
    to_port     = 22
  }

  ingress {
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 80
    to_port     = 80
  }

  egress {
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    to_port     = 0
  }
  tags = {
    Name                   = "staging"
    owner                  = "paritoshik.paul@srijan.net"
    stack                  = "demo"
    environment            = "dev"
  }

}

## Create Subnets
resource "aws_subnet" "public-subnet-1" {
  vpc_id     = "${aws_vpc.staging-vpc.id}"
  cidr_block = "172.16.10.0/24"
  map_public_ip_on_launch = "true"
  availability_zone = "ap-south-1a"

  tags = {
    Name                   = "staging"
    owner                  = "paritoshik.paul@srijan.net"
    stack                  = "demo"
    environment            = "dev"
  }

}

resource "aws_subnet" "private-subnet-1" {
  vpc_id                  = "${aws_vpc.staging-vpc.id}"
  cidr_block              = "172.16.10.1/24"
  map_public_ip_on_launch = "false"
  availability_zone       = "ap-south-1a"

  tags = {
    Name                   = "staging"
    owner                  = "paritoshik.paul@srijan.net"
    stack                  = "demo"
    environment            = "dev"
  }

}
## create Instance
resource "aws_instance" "staging-KMS" {
   ami = "${lookup(var.AMIS, var.AWS_REGION)}"
   instance_type = "t3a.medium"
vpc_security_group_ids =  [ "${aws_security_group.staging_sg.id}" ]
   subnet_id = "${aws_subnet.public-subnet_1.id}"
   key_name      = aws_key_pair.mykey.key_name
   count         = 1
   associate_public_ip_address = true
  tags = {
    Name                   = "staging"
    owner                  = "paritoshik.paul@srijan.net"
    stack                  = "demo"
    environment            = "dev"
  }

}

## create Internet Gateway
resource "aws_internet_gateway" "staging-gw" {
  vpc_id = "${aws_vpc.staging-vpc.id}"
  tags = {
    Name                   = "staging"
    owner                  = "paritoshik.paul@srijan.net"
    stack                  = "demo"
    environment            = "dev"
  }
  depends_on = ["aws_vpc.staging-vpc","aws_internet_gateway.staging-gw"]
}

##create Routetable
resource "aws_route_table" "main-route" {
   vpc_id = "${aws_vpc.staging-vpc.id}"
   route {
       cidr_block = "0.0.0.0/0"
       gateway_id = "${aws_internet_gateway.staging-gw.id}"
   }

  tags = {
    Name                   = "staging"
    owner                  = "paritoshik.paul@srijan.net"
    stack                  = "demo"
    environment            = "dev"
  }

   depends_on = ["aws_vpc.staging-vpc","aws_internet_gateway.staging-gw"]
}

resource "aws_route_table_association" "public-subnet-1-a" {
   subnet_id      = "${aws_subnet.public-subnet-1.id}"
   route_table_id = "${aws_route_table.main-route.id}"
}

