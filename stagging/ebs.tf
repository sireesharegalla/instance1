resource "aws_ebs_volume" "staging-ebs" {
  availability_zone = "ap-south-1a"
  size              = 30
  type              = "gp2"
  tags = {
    Name                   = "staging"
    owner                  = "paritoshik.paul@srijan.net"
    environment            = "dev"
  }

}

resource "aws_volume_attachment" "ebs-attachment" {
  device_name = "/dev/xvdh"
  volume_id   = aws_ebs_volume.staging-ebs.id
  instance_id = aws_instance.staging-KMS.id
}

