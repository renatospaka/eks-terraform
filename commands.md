# to change the context of the ks8 (local)
kubectl cluster-info --context kind-kind

# criando outro profile
aws configure --profile paka-sampa
aws configure --profile paka-ireland

# meu profilea na região do Óregon
aws configure set region us-east-2 --profile paka-ohio
aws configure set region sa-east-1 --profile paka-sampa
aws configure set region eu-west-1 --profile paka-ireland

# verifica qual é a região desse profile
<!-- aws configure get region --profile paka-ohio -->
export AWS_PROFILE=default
export AWS_PROFILE=paka-ohio
export AWS_PROFILE=paka-sampa
export AWS_PROFILE=paka-ireland

# mostra o setup atual
aws configure list
