

resource "aws_iam_group" "epam-tf-iam-group" {
  name = "Levon-Tonyan-01-group"

}


resource "aws_iam_policy" "policy" {
  name = "write-to-epam-tf-lab-${random_string.random.result}"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "Stmt1698757730436",
        "Action" : [
          "s3:PutObject",
          "ec2:DescribeInstances", 
          
        ],
        "Effect" : "Allow",
        "Resource" : ["arn:aws:s3:::${random_string.random.result}", "arn:aws:ec2:us-east-1:429881705512:instance/*"]
      
      }
    ]
  })
  tags = {
    Name      = "Levon-Tonyan-01-rt"
    Terraform = true
    Project   = "epam-tf-lab"
    Owner     = "Levon-Tonyan"
  }
}


resource "aws_iam_role" "write_to_s3" {
  name = "ec2_to_s3"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
  tags = {
    Name      = "Levon-Tonyan-01-rt"
    Terraform = true
    Project   = "epam-tf-lab"
    Owner     = "Levon-Tonyan"
  }
}



resource "aws_iam_policy_attachment" "attach-ec2-role" {
  name       = "ec2-attachment"
  roles      = [aws_iam_role.write_to_s3.name]
  policy_arn = aws_iam_policy.policy.arn

}


resource "aws_iam_instance_profile" "ec2-profile" {
  name = "ec2-profile"
  role = aws_iam_role.write_to_s3.name
  tags = {
    Name      = "Levon-Tonyan-01-rt"
    Terraform = true
    Project   = "epam-tf-lab"
    Owner     = "Levon-Tonyan"
  }
}