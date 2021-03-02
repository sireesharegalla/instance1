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
    environment            = "dev"
  }

}


resource "aws_security_group" "elb-securitygroup" {
  vpc_id      = "${aws_vpc.terraformfile.id}"
  name        = "elb-securitygroup"
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name                   = ""
    owner                  = ""
    environment            = "dev"
  }

}

