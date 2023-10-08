output "tf_ec2_public_ip" {
    description = "public ip of ec2"
    value = module.myapp_server.instance.public_ip
}

output "tf_ec2_private_ip" {
    description = "private ip of ec2"
    value = module.myapp_server.instance.private_ip
}

output "tf_ec2_instance_id" {
    description = "tf_ec2_instance_id"
    value = module.myapp_server.instance.id
}

##### myapp_new_server ##
output "new_tf_ec2_private_ip" {
    description = "new server private ip"
    value = module.myapp_new_server.instance.private_ip
}

output "new_tf_ec2_public_ip" {
    description = "public ip of new ec2"
    value = module.myapp_new_server.instance.public_ip
}
