data "aws_security_group" "ssh-inbound" {
  name = "ssh-inbound"
}
data "aws_security_group" "http-inbound" {
  name = "http-inbound"
}

data "aws_key_pair" "example" {
  key_name           = "epam-tf-ssh-key"
  include_public_key = true
}






resource "aws_launch_template" "epam-tf-lab" {
  name                   = "epam-tf-lab"
  image_id               = "ami-01eccbf80522b562b"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [data.aws_security_group.ssh-inbound.id, data.aws_security_group.http-inbound.id]
  key_name               = data.aws_key_pair.example.key_name
  iam_instance_profile {
    name = "ec2-profile"
  }
  network_interfaces {
    delete_on_termination = true
  }
  user_data = base64encode(data.template_file.bucket_name.rendered)
}


# data "terraform_remote_state" "storage" {
#   backend = "local"
#   config = {
#     path = "./../base/output.tf"
#   }




# }

data "template_file" "bucket_name" {
  template = "${file("user_data.sh")}"
  vars = {
    S3_BUCKET = "data.terraform_remote_state.storage.outputs.s3_bucket_name"
    COMPUTE_INSTANCE_ID = `${curl -X PUT "http://169.254.169.254/latest/instance-id"}
  }
}