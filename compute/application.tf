

data "aws_key_pair" "example" {
  key_name           = "epam-tf-ssh-key"
  include_public_key = true
}






resource "aws_launch_template" "epam-tf-lab" {
  name                   = "epam-tf-lab"
  image_id               = "ami-01eccbf80522b562b"
  instance_type          = "t2.micro"
  update_default_version = true


  key_name = data.aws_key_pair.example.key_name
  iam_instance_profile {
    name = "ec2-profile"
  }
  network_interfaces {
    delete_on_termination       = true
    associate_public_ip_address = true
    security_groups             = [data.terraform_remote_state.storage.outputs.security_group_id_ssh, data.terraform_remote_state.storage.outputs.security_group_id_http]
  }
  user_data = base64encode(data.template_file.bucket_name.rendered)


}


data "terraform_remote_state" "storage" {
  backend = "local"
  config = {
    path = "./../base/terraform.tfstate"
  }




}

data "template_file" "bucket_name" {
  template = file("./user_data.sh")

  vars = {
    S3_BUCKET = data.terraform_remote_state.storage.outputs.s3_bucket_name

  }
}