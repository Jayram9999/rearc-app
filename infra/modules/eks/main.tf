
####
## role and policy for eks cluster
####
resource "aws_iam_role" "eks_role" {
  name = "role-cluster-example"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "example-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_role.name
}

## Optionally, enable Security Groups for Pods
## Reference: https://docs.aws.amazon.com/eks/latest/userguide/security-groups-for-pods.html
resource "aws_iam_role_policy_attachment" "example-AmazonEKSVPCResourceController" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.eks_role.name
}

####
### fetch subnetids
####
##data "aws_subnets" "example" {
##  filter {
##    name   = "vpc-id"
##    values = [var.vpc_id]
##  }
##}
##
##data "aws_subnet" "example" {
##  for_each = toset(data.aws_subnets.example.ids)
##  id       = each.value
##}
##
##output "subnet_cidr_blocks" {
##  value = [for s in data.aws_subnet.example : s]
##}
#
#
####
## eks creation
####
resource "aws_eks_cluster" "wordpress_k8" {
  name     = var.cluster_name
  role_arn = aws_iam_role.eks_role.arn
  vpc_config {
    subnet_ids = [ var.priv_subnet_id, var.publ_subnet_id]
  }
  depends_on = [
    aws_iam_role.eks_role,
    aws_iam_role_policy_attachment.example-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.example-AmazonEKSVPCResourceController
  ]
}

#####
## EKS node group role
#####
resource "aws_iam_role" "eks_nodegroup_role" {
  name = "eks-node-group-example"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "example-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_nodegroup_role.name
}

resource "aws_iam_role_policy_attachment" "example-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_nodegroup_role.name
}

resource "aws_iam_role_policy_attachment" "example-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_nodegroup_role.name
}

######
### eks node group creation
######
resource "aws_eks_node_group" "wordpress_eks_ng" {
  cluster_name  = aws_eks_cluster.wordpress_k8.name
  node_group_name = "apps_ng1"
  node_role_arn = aws_iam_role.eks_nodegroup_role.arn
  subnet_ids    = [var.priv_subnet_id, var.publ_subnet_id]
  scaling_config {
    desired_size = 3
    max_size     = 4
    min_size     = 2
  }
  depends_on = [
    aws_iam_role.eks_nodegroup_role,
    aws_iam_role_policy_attachment.example-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.example-AmazonEC2ContainerRegistryReadOnly,
    aws_iam_role_policy_attachment.example-AmazonEKSWorkerNodePolicy
  ]
}

resource "null_resource" "kubeconfig_file" {
  provisioner "local-exec" {
    command = "aws eks update-kubeconfig --region us-east-1 --name ${var.cluster_name}"
  }
  depends_on = [aws_eks_node_group.wordpress_eks_ng]
}