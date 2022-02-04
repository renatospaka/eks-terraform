resource "aws_iam_role" "cluster-node-iam" {
  name = "${var.prefix}-${var.cluster_name}-node-role"
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
    "Name" = "${var.prefix}-${var.cluster_name}-node-role",
    "cliente" = "bid",
    "ambiente" = "dev"
  }
}

resource "aws_iam_role_policy_attachment" "cluster-node-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role = aws_iam_role.cluster-node-iam.name
}

resource "aws_iam_role_policy_attachment" "cluster-node-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role = aws_iam_role.cluster-node-iam.name
}

resource "aws_iam_role_policy_attachment" "cluster-node-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role = aws_iam_role.cluster-node-iam.name
}

resource "aws_eks_node_group" "node-grp-1" {
  node_group_name = "${var.prefix}-${var.cluster_name}-eks-grp-1"
  cluster_name = aws_eks_cluster.eks-cluster.name
  node_role_arn = aws_iam_role.cluster-node-iam.arn
  subnet_ids = aws_subnet.subnets[*].id
  instance_types = ["t3.medium"]
  scaling_config {
    desired_size = var.desired_size
    max_size = var.max_size
    min_size = var.min_size
  }
  depends_on = [
    aws_iam_role_policy_attachment.cluster-node-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.cluster-node-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.cluster-node-AmazonEC2ContainerRegistryReadOnly,
  ]
  tags = {
    "Name" = "${var.prefix}-${var.cluster_name}-eks-grp-1",
    "cliente" = "bid",
    "ambiente" = "dev"
  }
}

resource "aws_eks_node_group" "node-grp2" {
  node_group_name = "${var.prefix}-${var.cluster_name}-eks-grp-2"
  cluster_name = aws_eks_cluster.eks-cluster.name
  node_role_arn = aws_iam_role.cluster-node-iam.arn
  subnet_ids = aws_subnet.subnets[*].id
  instance_types = ["t3.micro"]
  scaling_config {
    desired_size = var.desired_size
    max_size = var.max_size
    min_size = var.min_size
  }
  depends_on = [
    aws_iam_role_policy_attachment.cluster-node-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.cluster-node-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.cluster-node-AmazonEC2ContainerRegistryReadOnly,
  ]
  tags = {
    "Name" = "${var.prefix}-${var.cluster_name}-eks-grp-2",
    "cliente" = "bid",
    "ambiente" = "dev"
  }
}
