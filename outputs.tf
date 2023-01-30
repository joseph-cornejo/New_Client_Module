output "instance_eip" {

  description = "Output for instance EIP"
  value = aws_instance.client_web-server-instance.public_ip

}

output "client_instance_id" {

  value = aws_instance.client_web-server-instance.id
}