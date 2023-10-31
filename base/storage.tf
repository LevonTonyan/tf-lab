
resource "aws_s3_bucket" "s3_epam" {
  bucket = "epam-tf-lab-${random_string.random.result}"

  tags = {
    Terraform = true
    Project   = "epam-tf-lab"
    Owner     = "Levon-Tonyan"
  }
}


resource "random_string" "random" {
  length           = 8
  override_special = "_ "
  special          = false
  lower            = true
  upper            = false
}


data "template_file" "bucke_name" {
  template = file("./../compute/user_data.sh")

  vars = {
    S3_BUCKET = "epam-tf-lab-${random_string.random.result}"
  }
}
