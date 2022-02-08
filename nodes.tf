resource "aws_iam_role" "eks-cluster-node-iam" {
  # name = "${var.prefix}-${var.web_cluster_name}-node-role"
  name = "${var.prefix}-eks-node-role"
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
  tags = {
    "Name" = "${var.prefix}-eks-node-role",
    "cliente" = var.client,
    "ambiente" = "dev"
  }
}

resource "aws_iam_role_policy_attachment" "cluster-node-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role = aws_iam_role.eks-cluster-node-iam.name
}

resource "aws_iam_role_policy_attachment" "cluster-node-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role = aws_iam_role.eks-cluster-node-iam.name
}

resource "aws_iam_role_policy_attachment" "cluster-node-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role = aws_iam_role.eks-cluster-node-iam.name
}

resource "aws_eks_node_group" "web-cluster-eks-grp-1" {
  node_group_name = "${var.prefix}-${var.web_cluster_name}-eks-grp-1"
  cluster_name = aws_eks_cluster.eks-cluster.name
  node_role_arn = aws_iam_role.eks-cluster-node-iam.arn
  subnet_ids = aws_subnet.web-subnets[*].id
  instance_types = ["t3.micro"]
  scaling_config {
    desired_size = var.web_desired_size
    max_size = var.web_max_size
    min_size = var.web_min_size
  }
  depends_on = [
    aws_iam_role_policy_attachment.cluster-node-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.cluster-node-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.cluster-node-AmazonEC2ContainerRegistryReadOnly,
  ]
  tags = {
    "Name" = "${var.prefix}-${var.web_cluster_name}-eks-grp-1",
    "cliente" = var.client,
    "ambiente" = "dev"
  }
}

# resource "aws_eks_node_group" "web-cluster-eks-grp-2" {
#   node_group_name = "${var.prefix}-${var.web_cluster_name}-eks-grp-2"
#   cluster_name = aws_eks_cluster.eks-cluster.name
#   node_role_arn = aws_iam_role.eks-cluster-node-iam.arn
#   subnet_ids = aws_subnet.web-subnets[*].id
#   instance_types = ["t3.micro"]
#   scaling_config {
#     desired_size = var.web_desired_size
#     max_size = var.web_max_size
#     min_size = var.web_min_size
#   }
#   depends_on = [
#     aws_iam_role_policy_attachment.cluster-node-AmazonEKSWorkerNodePolicy,
#     aws_iam_role_policy_attachment.cluster-node-AmazonEKS_CNI_Policy,
#     aws_iam_role_policy_attachment.cluster-node-AmazonEC2ContainerRegistryReadOnly,
#   ]
#   tags = {
#     "Name" = "${var.prefix}-${var.web_cluster_name}-eks-grp-2",
#     "cliente" = var.client,
#     "ambiente" = "dev"
#   }
# }
