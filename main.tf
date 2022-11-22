
data "aws_ami" "amazon-linux-2" {
    most_recent = true
    owners = [ "amazon" ]
    filter {
      name = "owner-alias"
      values = ["amazon"]
    }
    filter {
      name = "name"
      values =["amzn2-ami-hvm*"]
    }
}


resource "aws_instance" "my_ec2_bytf" {
    ami = "${data.aws_ami.amazon-linux-2.id}"
    instance_type = var.instance_type
    key_name = "${aws_key_pair.keyname.key_name}"
    vpc_security_group_ids = [aws_security_group.sg_my_server.id]
    user_data = data.template_file.userdata.rendered #we need to add rendered all the time we are referencing the file external project
    tags = {
      Name = var.server_name
    }
}

resource "aws_key_pair" "keyname" {
  key_name = "key-terraform"
  public_key = var.public_key
}

data "template_file" "userdata" {
  template = file("${abspath(path.module)}/userdata.yaml")
}

resource "aws_vpc" "mainvpc" {
  cidr_block = "10.1.0.0/16"
}
 
data "aws_vpc" "main" {
  id= var.vpc_id
  
}

resource "aws_security_group" "sg_my_server" {
  name = "sg_my_server"
  vpc_id = data.aws_vpc.main.id 

  ingress {
    description = "HTTP"
    protocol  = "tcp"
    self      = true
    from_port = 80
    to_port   = 80
    cidr_blocks =["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
    protocol  = "tcp"
    self      = true
    from_port = 22
    to_port   = 22
    cidr_blocks = [var.my_ip_with_cidr]
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}








