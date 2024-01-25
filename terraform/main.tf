resource "aws_instance" "backend" {
     ami           = aws_ami.latest_ubuntu.id
     instance_type = var.instance_type
     key_name      = "PEMFILE"
     iam_instance_profile = aws_iam_instance_profile.ec2_profile.name  # Use the instance profile
     
     tags = {
        Name = "backend"
        Enviroment = "dev"
        Team = "mobile-app"
        Type = "backend"
        }
}

resource "aws_instance" "database" {
     ami           = data.aws_ami.ubuntu_22.id
     instance_type = "t2.micro"
     key_name      = "PEMFILE"
     
     tags = {
        Name = "database"
        Enviroment = "dev"
        Team = "mobile-app"
        Type = "database"
        }
}

resource "local_file" "backend_ip" {
  content = aws_instance.backend.public_ip
  filename = "backend_ip.txt"
}

resource "local_file" "backend_ip" {
  content = aws_instance.database.private_ip
  filename = "database_ip.txt"
}