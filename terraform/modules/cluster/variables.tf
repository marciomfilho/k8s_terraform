variable "host" {
  description = "IP do servidor Ubuntu"
  type        = string
  default     = "192.168.15.158"
}

variable "user" {
  description = "Usuário SSH"
  type        = string
  default     = "marcio"
}

variable "private_key_path" {
  description = "Caminho local para chave SSH"
  type        = string
}
