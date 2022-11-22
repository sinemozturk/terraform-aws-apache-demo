output "instance_private_ip" {
  value = aws_instance.my_ec2_bytf.private_ip
}

output "instance_public_ip" {
  value = aws_instance.my_ec2_bytf.public_ip
}

output "instance_imageid" {
  value = aws_instance.my_ec2_bytf.ami
}
output "az" {
    value = aws_instance.my_ec2_bytf.availability_zone
  
}