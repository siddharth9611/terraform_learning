##### terraform state backend configuration for s3 bucket ######
/*terraform {
    backend "s3" {
        bucket = "terraformstate2054"
        key = "tfstate/state.tfstate"
        region = "ap-south-1"
    }
}*/

#### terraform cloud as remote for tf state file #####
terraform {
    required_providers {
        aws = {
        source = "hashicorp/aws"
    }
  }
    backend "remote" {
        organization = "terraform-cloud-2054"
        workspaces {
            name = "terraform_learning"
        }
    }
}

provider "aws" {
    region = "ap-south-1"
}

resource "aws_vpc" "tf_vpc"{
    cidr_block = var.tf_vpc_cidr_block
    tags = {
        Name = "${var.env_prefix}_tf_vpc"
        vpc_env = "dev"
    }
}

module "myapp_subnet" {
    source = "./modules/subnet"
    tf_subnet_cidr_block = var.tf_subnet_cidr_block
    avail_zone = var.avail_zone
    env_prefix = var.env_prefix
    vpc_id = aws_vpc.tf_vpc.id
}

module "myapp_server" {
    source = "./modules/server"
    vpc_id = aws_vpc.tf_vpc.id
    my_ip = var.my_ip
    env_prefix = var.env_prefix
    ami_id = var.ami_id
    avail_zone = var.avail_zone
    instance_type = var.instance_type
    subnet_id = module.myapp_subnet.subnet.id
}

module "myapp_new2_server" {
    source = "./modules/server"
    vpc_id = aws_vpc.tf_vpc.id
    my_ip = var.my_ip
    env_prefix = var.env_new_prefix
    ami_id = var.ami_id
    avail_zone = var.avail_zone
    instance_type = var.instance_type
    subnet_id = module.myapp_subnet.subnet.id
}



