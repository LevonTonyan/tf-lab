resource "aws_key_pair" "deployer" {
  key_name   = "epam-tf-ssh-key"
  public_key = var.ssh_key
}