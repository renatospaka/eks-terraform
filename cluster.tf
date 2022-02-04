resource "aws_security_group" "eks-sg" {
  vpc_id = aws_vpc.fullcycle-vpc.id

  # pode acessar qualquer coisa à partir do EKS
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
    "Name" = "${var.prefix}-sg ",
    "cliente" = "bid",
    "ambiente" = "dev"
  }
}

resource "aws_iam_role" "eks-cluster" {
  name = "${var.prefix}-${var.cluster_name}-role"
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


resource "aws_iam_role_policy_attachment" "eks-cluster-AmazonEKSVPCResourceController" {
  role = aws_iam_role.eks-cluster.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
}

resource "aws_iam_role_policy_attachment" "eks-cluster-AmazonEKSClusterPolicy" {
  role = aws_iam_role.eks-cluster.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}
