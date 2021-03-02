resource "aws_ebs_volume" "ebs" {
  availability_zone = "eu-west-1a"
  size              = 10
  type              = "gp2"
  tags = {
    Name                   = ""
    owner                  = ""
    environment            = "dev"
  }

}

resource "aws_volume_attachment" "ebs-attachment" {
  device_name = "/dev/xvdh"
  volume_id   = aws_ebs_volume.ebs.id
  instance_id = aws_instance.myproject.id
}

