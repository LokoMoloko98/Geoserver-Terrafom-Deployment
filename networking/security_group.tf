# create security group
resource "aws_security_group" "security_group" {
  name        = "${var.project_name}-sg"
  description = "Standard SG access"
  vpc_id      = aws_vpc.vpc.id
  tags = {
    Name = "${var.project_name}-sg"
  }
}

# create ingress rules
resource "aws_vpc_security_group_ingress_rule" "https_ingress" {
  security_group_id = aws_security_group.security_group.id
  description       = "https access"
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
  tags = {
    Name = "${var.project_name}-https"
  }
}


resource "aws_vpc_security_group_ingress_rule" "http_ingress" {
  security_group_id = aws_security_group.security_group.id
  description       = "https access"
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
  tags = {
    Name = "${var.project_name}-http"
  }
}

data "external" "myipaddr" {
  program = ["bash", "-c", "curl -s 'https://api.ipify.org?format=json'"]
}

resource "aws_vpc_security_group_ingress_rule" "ssh_ingress" {
  security_group_id = aws_security_group.security_group.id
  description       = "Secure Shell (SSH)"
  cidr_ipv4         = "${data.external.myipaddr.result.ip}/32"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
  tags = {
    Name = "${var.project_name}-ssh"
  }
}

# create single egress rule for all AZs
resource "aws_vpc_security_group_egress_rule" "egress" {
  security_group_id = aws_security_group.security_group.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = -1
  tags = {
    Name = "${var.project_name}-egress-rule"
  }
}