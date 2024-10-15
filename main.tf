#Generate an SSH key pair
resource "tls_private_key" "ec2_key_pair" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# create key
resource "aws_key_pair" "key_pair" {
  key_name   = "my-key"
  public_key = tls_private_key.ec2_key_pair.public_key_openssh
}

resource "aws_instance" "test-server" {
  ami = "ami-0e86e20dae9224db8"
  instance_type = "t2.micro"
  key_name = aws_key_pair.key_pair.key_name

  provisioner "remote-exec" {
     inline = ["echo 'wait to start the instance' "]
  }
  tags = {
     Name = "test-server"
     }
  provisioner "local-exec" {
     command = "echo ${aws_instance.test-server.public_ip} > inventory"
     }
  provisioner "local-exec" {
     command = "ansible-playbook /var/lib/jenkins/workspace/finance-project/ansibleplaybook.yml"
     }
  }
