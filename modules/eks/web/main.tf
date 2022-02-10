resource "aws_security_group" "eks-web-sg" {
  vpc_id = var.vpc_main_id
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    prefix_list_ids = []
    description = "free access from inside the SG"
    # name = "EKS-output"
  }
  tags = {
    "Name" = "${var.prefix}-eks-web-sg ",
    "cliente" = var.client,
    "ambiente" = "dev"
  }
}

resource "aws_iam_role" "cluster-iam" {
  name = "${var.prefix}-${var.web_cluster_name}-role"
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
  tags = {
    "Name" = "${var.prefix}-${var.web_cluster_name}-role",
    "cliente" = var.client,
    "ambiente" = "dev"
  }
}

resource "aws_iam_role_policy_attachment" "eks-cluster-AmazonEKSVPCResourceController" {
  role = aws_iam_role.cluster-iam.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
}

resource "aws_iam_role_policy_attachment" "eks-cluster-AmazonEKSClusterPolicy" {
  role = aws_iam_role.cluster-iam.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_cloudwatch_log_group" "eks-cluster-log" {
  name = "/aws/eks/${var.prefix}-${var.web_cluster_name}/cluster"
  retention_in_days = var.retention_days
}

resource "aws_eks_cluster" "eks-cluster" {
  name = "${var.prefix}-${var.web_cluster_name}-eks"
  role_arn = aws_iam_role.cluster-iam.arn
  enabled_cluster_log_types = ["api", "audit"]
  vpc_config {
    # subnet_ids = aws_subnet.web-subnets[*].id
    subnet_ids = var.web_subnet_ids
    security_group_ids = [aws_security_group.eks-web-sg.id]
  }
  depends_on = [
    aws_cloudwatch_log_group.eks-cluster-log,
    aws_iam_role_policy_attachment.eks-cluster-AmazonEKSVPCResourceController,
    aws_iam_role_policy_attachment.eks-cluster-AmazonEKSClusterPolicy,
  ]
  tags = {
    "Name" = "${var.prefix}-${var.web_cluster_name}-eks",
    "cliente" = var.client,
    "ambiente" = "dev"
  }
}

########################################
# início da criação dos nodes do cluster

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
  # subnet_ids = aws_subnet.web-subnets[*].id
  subnet_ids = var.web_subnet_ids
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
