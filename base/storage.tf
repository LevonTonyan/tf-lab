
resource "aws_s3_bucket" "s3_epam" {
  bucket = "epam-tf-lab-${random_string.random.result}"

  tags = {
    Name      = "Levon-Tonyan-01-rt"
    Terraform = true
    Project   = "epam-tf-lab"
    Owner     = "Levon-Tonyan"
  }
}


resource "random_string" "random" {
  length           = 16
  special          = true
  override_special = "/@£$"
}