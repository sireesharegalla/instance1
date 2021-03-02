resource "aws_s3_bucket" "my_first_bucket" {
   bucket = "testing-s3-with-terraform"
   acl = "private"
   versioning {
      enabled = true
   }
   tags = {
    Name                   = ""
    owner                  = ""
    environment            = "dev"
  }
}I
