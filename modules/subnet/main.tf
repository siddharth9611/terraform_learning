resource "aws_subnet" "tf_subnet" {
    vpc_id = var.vpc_id
    cidr_block = var.tf_subnet_cidr_block
    availability_zone = var.avail_zone
    tags = {
      Name = "${var.env_prefix}_tf_subnet"
    }
}

resource "aws_internet_gateway" "tf_igw" {
  vpc_id = var.vpc_id

  tags = {
    Name = "${var.env_prefix}_tf_route"
    }
}

resource "aws_route_table" "tf_route_table" {
  vpc_id = var.vpc_id

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