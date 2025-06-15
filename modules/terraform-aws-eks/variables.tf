variable "vpc_id" {
  description = "The VPC ID"
  type        = string
}
variable "private_subnet_ids" {
  description = "The Private subent ids"
  type        = list(string)
}
variable "public_subnet_ids" {
  description = "The public subnet ids"
  type        = list(string)
}

variable "cluster_role_arn" {
  description = "cluster_role_arn"
  type        = string
}

variable "node_role_arn" {
  description = "node_role_arn"
  type        = string
}

variable "cluster_role_dependency" {
  description = "cluster_role_dependency"
  type        = any
}

variable "eks_oidc_root_ca_thumbprint" {
}

#variable "aws_eks_cluster_identity" {
#}