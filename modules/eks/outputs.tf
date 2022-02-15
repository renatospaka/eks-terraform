########################################
# web public EKS kubeconfig  
locals {
  kubeconfig-web = <<KUBECONFIG
apiVersion: v1
clusters:
- cluster:
    server: ${aws_eks_cluster.web-eks-cluster.endpoint}
    certificate-authority-data: ${aws_eks_cluster.web-eks-cluster.certificate_authority[0].data}
  name: kubernetes
contexts:
- context:
#     cluster: kubernetes
    user: "${aws_eks_cluster.web-eks-cluster.name}"
  name: "${aws_eks_cluster.web-eks-cluster.name}"
current-context: "${aws_eks_cluster.web-eks-cluster.name}"
kind: Config
preferences: {}
users:
- name: "${aws_eks_cluster.web-eks-cluster.name}"
  user:
    exec:
      apiVersion: client.authentication.k8s.io/v1alpha1
      command: aws-iam-authenticator
      args:
        - "token"
        - "-i"
        - "${aws_eks_cluster.web-eks-cluster.name}"
KUBECONFIG
}

resource "local_file" "kubeconfig-web" {
  filename = "kubeconfig-web"
  content = local.kubeconfig-web
}


########################################
# api private EKS kubeconfig  
locals {
  kubeconfig-api = <<KUBECONFIG
apiVersion: v1
clusters:
- cluster:
    server: ${aws_eks_cluster.api-eks-cluster.endpoint}
    certificate-authority-data: ${aws_eks_cluster.api-eks-cluster.certificate_authority[0].data}
  name: kubernetes
contexts:
- context:
#     cluster: kubernetes
    user: "${aws_eks_cluster.api-eks-cluster.name}"
  name: "${aws_eks_cluster.api-eks-cluster.name}"
current-context: "${aws_eks_cluster.api-eks-cluster.name}"
kind: Config
preferences: {}
users:
- name: "${aws_eks_cluster.api-eks-cluster.name}"
  user:
    exec:
      apiVersion: client.authentication.k8s.io/v1alpha1
      command: aws-iam-authenticator
      args:
        - "token"
        - "-i"
        - "${aws_eks_cluster.api-eks-cluster.name}"
KUBECONFIG
}

resource "local_file" "kubeconfig-api" {
  filename = "kubeconfig-api"
  content = local.kubeconfig-api
}
