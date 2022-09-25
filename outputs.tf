output "instance_eip" {

  value = aws_eip.client_one

}

output "client_instance_id" {

  value = aws_instance.client_web-server-instance.id
}