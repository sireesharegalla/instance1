## Create VPC ##
resource "aws_vpc" "terraformfile" {
  cidr_block       = "172.16.0.0/16"
  enable_dns_hostnames = true

  tags = {
   Name                   = ""
   owner                  = ""
   stack                  = "demo"
   environment            = "dev"
  }

}

## Security Group##
resource "aws_security_group" "terraformfile_sg" {
  description = "Allow limited inbound external traffic"
  vpc_id      = "${aws_vpc.terraformfile.id}"
  name        = "terraform_sg"

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
    Name                   = ""
    owner                  = ""
    stack                  = "demo"
    environment            = "dev"
  }

}

## Create Subnets
resource "aws_subnet" "public-subnet_1" {
  vpc_id     = "${aws_vpc.terraformfile.id}"
  cidr_block = "172.16.10.0/24"
  map_public_ip_on_launch = "true"
  availability_zone = "us-east-1a"

  tags = {
    Name                   = ""
    owner                  = ""
    stack                  = "demo"
    environment            = "dev"
  }

}

resource "aws_subnet" "private-subnet_1" {
  vpc_id                  = "${aws_vpc.terraformfile.id}"
  cidr_block              = "172.16.10.1/24"
  map_public_ip_on_launch = "false"
  availability_zone       = "us-east-1a"

  tags = {
    Name                   = ""
    owner                  = ""
    stack                  = "demo"
    environment            = "dev"
  }

}
## create Instance
resource "aws_instance" "myproject" {
   ami = "${lookup(var.AMIS, var.AWS_REGION)}"
   instance_type = "t2.micro"
vpc_security_group_ids =  [ "${aws_security_group.terraformfile_sg.id}" ]
   subnet_id = "${aws_subnet.public-subnet_1.id}"
   key_name      = aws_key_pair.mykey.key_name
   count         = 1
   associate_public_ip_address = true
  tags = {
    Name                   = ""
    owner                  = ""
    stack                  = "demo"
    environment            = "dev"
  }

}

## create Internet Gateway
resource "aws_internet_gateway" "my-gw" {
  vpc_id = "${aws_vpc.terraformfile.id}"
  tags = {
    Name                   = ""
    owner                  = ""
    stack                  = "demo"
    environment            = "dev"
  }
  depends_on = ["aws_vpc.terraformfile","aws_internet_gateway.my-gw"]
}

##create Routetable
resource "aws_route_table" "main-route" {
   vpc_id = "${aws_vpc.terraformfile.id}"
   route {
       cidr_block = "0.0.0.0/0"
       gateway_id = "${aws_internet_gateway.my-gw.id}"
   }

  tags = {
    Name                   = ""
    owner                  = ""
    stack                  = "demo"
    environment            = "dev"
  }

   depends_on = ["aws_vpc.terraformfile","aws_internet_gateway.my-gw"]
}

resource "aws_route_table_association" "public-subnet_1-a" {
   subnet_id      = "${aws_subnet.public-subnet_1.id}"
   route_table_id = "${aws_route_table.main-route.id}"
}

