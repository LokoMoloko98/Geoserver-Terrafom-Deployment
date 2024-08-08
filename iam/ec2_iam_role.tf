#Create an IAM role
resource "aws_iam_role" "modular-template-EC2-role" {
  name = "${var.project_name}-iam-role"
  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    tag-key = "${var.project_name}-iam-role"
  }
}

#EC2 policy
resource "aws_iam_policy_attachment" "ec2-role-attachment" {
  name       = "${var.project_name}-${var.region}-ec2-role-attachment"
  roles      = [aws_iam_role.modular-template-EC2-role.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}

#SSM policy 1
resource "aws_iam_policy_attachment" "SSM-role-attachment" {
  name       = "${var.project_name}-${var.region}-SSM-role-attachment"
  roles      = [aws_iam_role.modular-template-EC2-role.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

#SSM policy 2
resource "aws_iam_policy_attachment" "SSM-EC2-role-attachment" {
  name       = "${var.project_name}-${var.region}-SSM-EC2-role-attachment"
  roles      = [aws_iam_role.modular-template-EC2-role.name]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
}

#Route53 policy
resource "aws_iam_policy_attachment" "route53-role-attachment" {
  name       = "${var.project_name}-${var.region}-route53-role-attachment"
  roles      = [aws_iam_role.modular-template-EC2-role.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonRoute53FullAccess"
}


#Attach role to an instance profile
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2_profile"
  role = aws_iam_role.modular-template-EC2-role.name
}