output "vpc_id" {
  value = aws_vpc.vpc.id
}

data "aws_subnets" "public_subnets" {
  filter {
    name   = "vpc-id"
    values = [aws_vpc.vpc.id]
  }
}

output "public_subnets" {
  value = data.aws_subnets.public_subnets.ids
}
////////////////////////////////////////
output "security_group_id_ssh" {
  value = aws_security_group.ssh-inbound.id
}

output "security_group_id_http" {
  value = aws_security_group.http-inbound.id
}

output "security_group_id_http_lb" {
  value = aws_security_group.lb_http-inbound.id
}
///////////////////////////////////////////

output "iam_instance_profile_name" {
  value = aws_iam_instance_profile.ec2-profile.name
}

output "key_name" {
  value = aws_key_pair.deployer.key_name
}

output "s3_bucket_name" {
  value = random_string.random.result
}
