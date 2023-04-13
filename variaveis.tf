variable "region" {
  type        = string
  description = "Regiao"
  default     = "us-east-2"

}

variable "ami" {
  type        = string
  description = ""
  default     = "ami-0cc87e5027adcdca8"

}

variable "instance_type" {
  type        = string
  description = ""
  default     = "t2.micro"

}

variable "user_ssh" {
  type        = string
  description = "Usuario SSH"
  default     = "ec2-user"
}


variable "recurso" {
  type        = string
  description = "Recurso usado"
  default     = "ecs"

}

variable "cluster" {
  type        = string
  description = "Nome do Cluster"
  default     = "Terraform"

}

variable "servico" {
  type        = string
  description = "Nome do Serviço"
  default     = "Wordpress"

}

