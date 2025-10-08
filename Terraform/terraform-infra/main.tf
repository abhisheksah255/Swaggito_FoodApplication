resource "aws_instance" "web" {
  ami           = "ami-0360c520857e3138f" # Amazon Linux 2 AMI (us-east-1)
  instance_type = "t2.medium"
  key_name      = "my-key-pair" # Replace with your key pair name
  #   subnet_id     = aws_subnet.main.id
  vpc_security_group_ids = [aws_security_group.my_cicd_project.id]
  user_data              = templatefile("./install.sh", {})

  #   associate_public_ip_address = true

  tags = {
    Name = "my_cicd_project"
  }

  root_block_device {
    volume_size = 20
  }
}


resource "aws_security_group" "my_cicd_project" {
  name        = "my_cicd_project"
  description = "Allow SSH and HTTP"
  #   vpc_id      = aws_vpc.main.id

  ingress = [
    for port in [22, 80, 443, 8080, 9000, 3000] : {
      description      = "inbound rules"
      from_port        = port
      to_port          = port
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "my_cicd_project"

  }
}

# here is the backend configuration for terraform state management s3 and dynamodb for state locking




# these are VPC releted stuff commented for now as we are using default VPC

# resource "aws_vpc" "main" {
#   cidr_block = "10.0.0.0/16"
#   tags = {
#     Name = "main-vpc"
#   }
# }

# resource "aws_subnet" "main" {
#   vpc_id                  = aws_vpc.main.id
#   cidr_block              = "10.0.1.0/24"
#   availability_zone       = "us-east-1a"
#   map_public_ip_on_launch = true
#   tags = {
#     Name = "main-subnet"
#   }
# }

# resource "aws_internet_gateway" "gw" {
#   vpc_id = aws_vpc.main.id
#   tags = {
#     Name = "main-igw"
#   }
# }

# resource "aws_route_table" "rt" {
#   vpc_id = aws_vpc.main.id
#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_internet_gateway.gw.id
#   }
#   tags = {
#     Name = "main-rt"
#   }
# }

# resource "aws_route_table_association" "a" {
#   subnet_id      = aws_subnet.main.id
#   route_table_id = aws_route_table.rt.id
# }

