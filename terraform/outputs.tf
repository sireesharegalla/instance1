output "aws_vpc_id" {
  value = "$aws_vpc.{terraformfile.id}"
}

output "aws_security_gr_id" {
  value = "${aws_security_group.terraformfile_sg.id}"
}

output "aws_subnet_id" {
  value = "${aws_subnet.public-subnet_1.id}"
}

output "instance_id_list"     { 
  value = ["${aws_instance.myproject.*.id}"]
}


