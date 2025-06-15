# resource "aws_iam_role" "eks_cluster_role" {
#   name = "EKSClusterRole-Flask"

#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Effect = "Allow"
#         Principal = {
#           Service = "eks.amazonaws.com"
#         }
#         Action = "sts:AssumeRole"
#       }
#     ]
#   })
# }

# resource "aws_iam_role" "eks_node_role" {
#   name = "AmazonEKSNodeRole-Flask"

#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Effect = "Allow"
#         Principal = {
#           Service = "ec2.amazonaws.com"
#         }
#         Action = "sts:AssumeRole"
#       }
#     ]
#   })
# }
# resource "aws_iam_role_policy_attachment" "eks_cluster_policy_attachment" {
#   role       = aws_iam_role.eks_cluster_role.name
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
# }

# resource "aws_iam_role_policy_attachment" "AmazonEKS_CNI_Policy" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
#   role       = aws_iam_role.eks_node_role.name
# }

# resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryReadOnly" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
#   role       = aws_iam_role.eks_node_role.name
# }

resource "aws_eks_cluster" "eks" {
  name     = "EKS"
  role_arn = var.cluster_role_arn
  version  = "1.32"
  # endpoint_private_access = var.cluster_endpoint_private_access
  # endpoint_public_access  = var.cluster_endpoint_public_access
  # public_access_cidrs     = var.cluster_endpoint_public_access_cidrs
  vpc_config {
    subnet_ids = var.private_subnet_ids
  }
}

# resource "aws_iam_role_policy_attachment" "eks_worker_node_policy" {
#   role       = aws_iam_role.eks_node_role.name
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
# }

# resource "aws_iam_role_policy_attachment" "eks_cni_policy" {
#   role       = aws_iam_role.eks_node_role.name
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
# }

# resource "aws_iam_role_policy_attachment" "ec2_container_registry_read_only" {
#   role       = aws_iam_role.eks_node_role.name
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
# }
resource "aws_security_group" "eks" {
  name        = "eks-sg"
  description = "EKS security group"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "eks-sg"
  }
}


resource "aws_eks_node_group" "ng" {
  cluster_name    = aws_eks_cluster.eks.name
  node_group_name = "node_group_flask"
  node_role_arn   = var.node_role_arn
  subnet_ids      = var.public_subnet_ids
  instance_types  = ["t2.medium"]
  scaling_config {
    desired_size = 1
    max_size     = 3
    min_size     = 1
  }
  disk_size = 20
  update_config {
    max_unavailable = 1
  }
  depends_on = [aws_eks_cluster.eks]
}


data "aws_partition" "current" {}

# Resource: AWS IAM Open ID Connect Provider
resource "aws_iam_openid_connect_provider" "oidc_provider" {
  client_id_list  = ["sts.${data.aws_partition.current.dns_suffix}"]
  thumbprint_list = [var.eks_oidc_root_ca_thumbprint]
  url             = aws_eks_cluster.eks.identity[0].oidc[0].issuer

  tags = {
    Name = "eks-irsa"
  }
}

# Extract OIDC Provider from OIDC Provider ARN
locals {
  aws_iam_oidc_connect_provider_extract_from_arn = element(split("oidc-provider/", "${aws_iam_openid_connect_provider.oidc_provider.arn}"), 1)
}