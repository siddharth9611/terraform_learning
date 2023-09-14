provider "aws" {
    region = "ap-south-1"
}

variable tf_vpc_cidr_block{}
variable tf_subnet_cidr_block{}
variable avail_zone {}
variable env_prefix{}
variable "my_ip" {}
variable "instance_type" {}


resource "aws_vpc" "tf_vpc"{
    cidr_block = var.tf_vpc_cidr_block
    tags = {
        Name = "${var.env_prefix}_tf_vpc"
        vpc_env = "dev"
    }
}

resource "aws_subnet" "tf_subnet" {
    vpc_id = aws_vpc.tf_vpc.id
    cidr_block = var.tf_subnet_cidr_block
    availability_zone = var.avail_zone
    tags = {
      Name = "${var.env_prefix}_tf_subnet"
    }
}

resource "aws_internet_gateway" "tf_igw" {
  vpc_id = aws_vpc.tf_vpc.id

  tags = {
    Name = "${var.env_prefix}_tf_route"
    }
}

resource "aws_route_table" "tf_route_table" {
  vpc_id = aws_vpc.tf_vpc.id

  tags = {
    Name = "${var.env_prefix}_tf_route"
  }

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.tf_igw.id
    }
}

resource "aws_route_table_association" "tf_rote_association" {
    subnet_id = aws_subnet.tf_subnet.id
    route_table_id = aws_route_table.tf_route_table.id
}

######### using default route table ########## 
### no need to do subnet asssociation as its done by default ###

/*resource "aws_default_route_table" "tf_default_rote_table" {
    default_route_table_id = aws_vpc.tf_vpc.default_route_table_id
    
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.tf_igw.id
    }

    tags = {
        Name = "${var.env_prefix}_tf_default_route"
  }
}*/

resource "aws_security_group" "tf_sg" {
    name = "tf_learn_sg"
    vpc_id = aws_vpc.tf_vpc.id

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = [var.my_ip]
    }

    ingress {
        from_port = 8080
        to_port = 8080
        protocol = "tcp"
        cidr_blocks = [var.my_ip]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "all"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
      Name = "${var.env_prefix}_tf_sg"
    }
}

### default security group ####

/*resource "aws_default_security_group" "tf_default_sg" {
    vpc_id = aws_vpc.tf_vpc.id

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = [var.my_ip]
    }

    ingress {
        from_port = 8080
        to_port = 8080
        protocol = "tcp"
        cidr_blocks = [var.my_ip]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "all"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
      Name = "${var.env_prefix}_tf_default_sg"
    }
}*/

##### key pair creation using terraform code #########
##### we used ssh-keygen command to create keypar in local and add public key to variable or in key name ######

/*resource "aws_key_pair" "tf_key_learn" {
    key_name = "tf_key_learn"
    public_key = var.tf_pub_key
}*/

resource "aws_instance" "tf_ec2" {
    ami = "ami-05552d2dcf89c9b24"
    instance_type = var.instance_type
    subnet_id = aws_subnet.tf_subnet.id
    availability_zone = var.avail_zone
    security_groups = [aws_security_group.tf_sg.id]
    associate_public_ip_address = true  
    key_name = "tf_key_pair"
    tags = {
        Name = "${var.env_prefix}_tf_ec2"
    } 
}

output "tf_ec2_public_ip" {
    description = "public ip of ec2"
    value = aws_instance.tf_ec2.public_ip
}

output "tf_ec2_private_ip" {
    description = "private ip of ec2"
    value = aws_instance.tf_ec2.private_ip
}