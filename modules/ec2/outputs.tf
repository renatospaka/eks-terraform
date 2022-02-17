output "ssh_private_key_pem" {
  sensitive = true
  value = tls_private_key.ssh.private_key_pem
}

output "ssh_public_key_pem" {
  value = tls_private_key.ssh.public_key_pem
}

output "sg-developers" {
  value = aws_security_group.developers-sg.id
}
