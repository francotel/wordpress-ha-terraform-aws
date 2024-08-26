variable "env" {
  type        = string
  description = "Environment name."
}

variable "project" {
  description = "Project Name or service"
  type        = string
}

variable "owner" {
  description = "Owner Name or service"
  type        = string
}

variable "cost" {
  description = "Center of cost"
  type        = string
}

variable "tf_version" {
  description = "Terraform version that used for the project"
  type        = string
}

# variable "vpcs" {
#   description = "Map of VPC configurations"
#   type = map(object({
#     cidr            = string
#     azs             = list(string)
#     private_subnets = list(string)
#     public_subnets  = list(string)
#   }))
# }

variable "domain" {
  description = "domain website hosted in Route53"
  type        = string
}