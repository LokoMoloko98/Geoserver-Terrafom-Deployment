data "aws_ssm_parameter" "route_53_hostzone_id" {
  name            = "route_53_hostzone_id"
  with_decryption = true
}

data "template_file" "user_data" {
  template = file("${path.module}/user_data.sh")
  vars = {
    region   = var.region
    hostzone = data.aws_ssm_parameter.route_53_hostzone_id.value
  }
}

resource "aws_instance" "modular-template-node" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = var.ssh_key_pair
  iam_instance_profile   = var.instance_profile
  user_data              = data.template_file.user_data.rendered
  vpc_security_group_ids = [var.security_group_id]
  subnet_id              = var.subnet_id

  root_block_device {
    volume_type           = "gp3"
    volume_size           = "30"
    delete_on_termination = "true"
    encrypted             = "true"
  }
}
