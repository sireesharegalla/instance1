output "aws_vpc_id" {
  value = "$aws_vpc.{staging-vpc.id}"
}

output "aws_security_gr_id" {
  value = "${aws_security_group.staging_sg.id}"
}

output "aws_subnet_id" {
  value = "${aws_subnet.public-subnet-1.id}"
}

output "instance_id_list"     { 
  value = ["${aws_instance.staging-KMS.*.id}"]
}

