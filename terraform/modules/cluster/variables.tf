variable "host" {
  description = "IP do servidor Ubuntu"
  type        = string
}

variable "user" {
  description = "Usuário SSH"
  type        = string
}

variable "private_key_path" {
  description = "Caminho local para chave SSH"
  type        = string
}
