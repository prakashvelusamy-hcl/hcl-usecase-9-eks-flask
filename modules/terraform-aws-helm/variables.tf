variable "cluster_id" {
}
variable "cluster_endpoint" {
}
variable "cluster_certificate_authority_data" {
}
variable "lbc_iam_depends_on" {
}
variable "region" {
}
variable "lbc_iam_role_arn" {
  description = "IAM role ARN for Load Balancer Controller"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID for the EKS cluster"
  type        = string
}