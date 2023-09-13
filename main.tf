provider "aws" {
    region = "ap-south-1"
}

resource "aws_vpc" "vscode"{
    cidr_block = "10.0.0.0/22"
    tags = {
        Name = "vscode_vpc"
        vpc_env = "de"
    }
}

output "dev-vp-id" {
  value       = aws_vpc.vscode.id
  description = "VPCid"
}
