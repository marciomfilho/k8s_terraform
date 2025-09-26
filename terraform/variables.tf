variable "host" {
  description = "IP do servidor Ubuntu"
  type        = string
  default     = "192.168.15.158"
}

variable "user" {
  description = "Usuário SSH do servidor"
  type        = string
  default     = "ubuntu"
}

variable "private_key_path" {
  description = "Caminho para chave privada SSH"
  type        = string
  default     = "~/.ssh/id_rsa"
}
