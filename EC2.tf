# Security Group
resource "aws_security_group" "allow_ssh" {
  vpc_id = aws_vpc.my_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow SSH from anywhere
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] # Allow all outbound traffic
  }

  tags = {
    Name = "AllowSSH"
  }
}

# EC2 Instance
resource "aws_instance" "example" {
  ami                         = "ami-0240c620957e314cf" # Ubuntu 22.04 in us-east-1
  instance_type               = "t2.nano"               # ✅ smaller instance to avoid vCPU limit error
  subnet_id                   = aws_subnet.public_subnet.id
  vpc_security_group_ids      = [aws_security_group.allow_ssh.id]
  associate_public_ip_address = true
  key_name                    = "aws-key-pair"          # ✅ your uploaded key pair name

  tags = {
    Name = "MyTerraformEC2"
  }
}
