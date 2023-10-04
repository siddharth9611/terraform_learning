resource "aws_security_group" "tf_sg" {
    name = "tf_learn_sg"
    vpc_id = var.vpc_id

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
    ami = var.ami_id
    instance_type = var.instance_type
    subnet_id = var.subnet_id
    availability_zone = var.avail_zone
    security_groups = [aws_security_group.tf_sg.id]
    associate_public_ip_address = true  
    key_name = "tf_key_pair"
    tags = {
        Name = "${var.env_prefix}_tf_ec2"
    } 
}
