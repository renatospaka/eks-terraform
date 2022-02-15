# aws profiles
## create new profiles
aws configure --profile paka-sampa
aws configure --profile paka-ireland

## configure existing profiles
aws configure set region us-east-2 --profile paka-ohio
aws configure set region sa-east-1 --profile paka-sampa
aws configure set region eu-west-1 --profile paka-ireland

## set the current AWS profile
<!-- aws configure get region --profile paka-ohio -->
export AWS_PROFILE=default
export AWS_PROFILE=paka-ohio
export AWS_PROFILE=paka-sampa
export AWS_PROFILE=paka-ireland

## show the current AWS profile 
aws configure list

# terraform cli
## analyze and plan the script
terraform validate
terraform plan out bid.out

## execute the planning infra
terraform apply --auto-approve bid.out

# aws-iam-authenticator
## check the current aws-iam-authenticator setup
chmod +x aws-iam-authenticator
sudo mv aws-iam-authenticator /usr/local/bin
aws-iam-authenticator help

# kubernets
## copy the kubeconfig to local folder (must be in path)
cp kubeconfig ~/.kube/config
kubectl get nodes

## to change the context of the ks8 (local)
kubectl cluster-info --context kind-kind

