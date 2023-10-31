resource "aws_key_pair" "deployer" {
  key_name   = "epam-tf-ssh-key"
  public_key = var.ssh_key
  tags = {
    Terraform = true
    Project   = "epam-tf-lab"
    Owner     = "Levon-Tonyan"
  }
}