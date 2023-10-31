
resource "aws_s3_bucket" "s3_epam" {
  bucket = "epam-tf-lab-${random_string.my_numbers.result}"

  tags = {
    Name      = "Levon-Tonyan-01-rt"
    Terraform = true
    Project   = "epam-tf-lab"
    Owner     = "Levon-Tonyan"
  }
}