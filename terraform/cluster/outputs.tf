output "key_name" {
  description = "key name"
  value       = aws_key_pair.my_ssh_public_key.key_name
}