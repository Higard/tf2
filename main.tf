provider "aws" {
  region = "us-east-1"
}

locals {
  instance_name_format = "${var.instance_name_prefix}-%02d"
  ami_id               = data.aws_ssm_parameter.ami.value
}

resource "aws_instance" "example" {
  count         = var.instance_count
  ami           = local.ami_id
  instance_type = "t2.micro"
  user_data     = <<-EOF
                  #!/bin/bash
                  echo "Hello, World!" > /tmp/hello.txt
                  EOF

  tags = {
    Name = format(local.instance_name_format, count.index + 1)
  }
}

data "aws_ssm_parameter" "ami" {
  name = var.ami_parameter_name
}

output "private_ips" {
  value = aws_instance.example[*].private_ip
}
