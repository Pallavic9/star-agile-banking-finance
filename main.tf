resource "aws_security_group" "allow_ssh" {
  name_prefix = "allow_ssh"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "tls_private_key" "my_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "aws_key_pair" "generated_key" {
  key_name   = "generated-key"
  public_key = tls_private_key.my_key.public_key_openssh
}

resource "aws_instance" "test-server" {
  ami = "ami-0e86e20dae9224db8"
  instance_type = "t2.micro"
  key_name = aws_key_pair.generated_key.key_name

  provisioner "remote-exec" {
      connection {
      type        = "ssh"
      user        = "ubuntu"             # Use the default user for your AMI
      private_key = tls_private_key.my_key.private_key_openssh  # Path to the private key that matches the public key
      host        = self.public_ip         # Use the instance’s public IP
    }
     inline = ["echo 'wait to start the instance' "]
  }
  tags = {
     Name = "test-server"
     }
  provisioner "local-exec" {
     command = "echo ${aws_instance.test-server.public_ip} > inventory"
     }
 provisioned "file-exec" {
      
  provisioner "local-exec" {
     command = "ansible-playbook /var/lib/jenkins/workspace/finance-project/ansible-playbook.yml"
     }
  }
}
