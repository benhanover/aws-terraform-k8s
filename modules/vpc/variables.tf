variable "env" {
  description = "The environment"
  type        = string
  default     = "dev"
}

variable "region" {
  description = "The region"
  type        = string
  default     = "us-east-1"
}

variable "zone1" {
  description = "The first availability zone"
  type        = string
  default     = "us-east-1a"
}

variable "zone2" {
  description = "The second availability zone"
  type        = string
  default     = "us-east-1b"

}

variable "public_nacl_id" {
  description = "The ID of the public NACL"
  type        = string
}

variable "private_nacl_id" {
  description = "The ID of the private NACL"
  type        = string
} 