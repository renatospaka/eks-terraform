# aws profiles
## create new profiles
aws configure --profile paka-sampa
aws configure --profile d3-sp

## configure existing profiles
aws configure set region us-east-2 --profile paka-ohio
aws configure set region sa-east-1 --profile paka-sampa
aws configure set region sa-east-1 --profile d3-sp

## set the current AWS profile
<!-- aws configure get region --profile paka-ohio -->
export AWS_PROFILE=paka-ohio
export AWS_PROFILE=paka-sampa
export AWS_PROFILE=d3-sp

## show the current AWS profile 
aws configure list

# terraform cli
## analyze and plan the script
terraform validate
terraform plan -out bid.out

## execute the planning infra
terraform apply --auto-approve bid.out
terraform destroy 

# aws-iam-authenticator
## check the current aws-iam-authenticator setup
chmod +x aws-iam-authenticator
sudo mv aws-iam-authenticator /usr/local/bin
aws-iam-authenticator help

# kubernets
## copy the kubeconfig to local folder (must be in path)
cp kubeconfig-api ~/.kube/config
cp kubeconfig-web ~/.kube/config
kubectl get nodes

## to change the context of the ks8 (local)
kubectl cluster-info --context kind-kind

# SSH Tunneling to access RDS (postgres) on private subnet
## -> keep the pem file safe from destruction
## cp -f d3-bid-ec2-kp.pem pem/
## -> after terraform apply finishes with no errors
## chmod 400 d3-bid-ec2-kp.pem
## -> copy the content of the key-pair (pem)
## ssh -i d3-bid-ec2-kp.pem ec2-user@<ip of bastion server>
## -> in the bastion server (d3-bid-web-public-ec2)
## nano ~/.ssh/d3-bid-ec2-kp.pem
## -> paste the content of the key-pair (pem), save and exit
## chmod 400 ~/.ssh/d3-bid-ec2-kp.pem
## -> ready to go
