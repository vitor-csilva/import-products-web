#!/bin/bash

function _install_kind () {
    #Apenas para AMD64 / x86_64
    [ $(uname -m) = x86_64 ] && curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.20.0/kind-linux-amd64
    chmod +x ./kind
    sudo mv ./kind /usr/local/bin/kind
}

#Verificando se ja existe o kind instalado na máquina
kind version || _install_kind

#Criando o cluster e parametrizando o kubectl
kind create cluster  --config ./k8s/config.yaml --name k8s-prova --kubeconfig ./k8s/config
export KUBECONFIG=./k8s/config
kubectl apply -f ./k8s/deployments/deployment-db-import-products.yaml
kubectl apply -f ./k8s/services/service-db-import-products.yaml
kubectl apply -f ./k8s/deployments/deployment-import-products.yaml
kubectl apply -f ./k8s/services/service-import-products.yaml
kubectl apply -f ./k8s/hpa/hpa.yaml

#Executando a pipeline(build, gerar tag, push da imagem, att da tag da imagem)
./pipeline.sh


######## Comandos para testes ########

#kubectl expose deployment app-prova --port 8080 --target-port 8080 --port 8081 --target-port 8081
# k create deployment --image vitorcostasilva/app-prova:3.0 app-prova --dry-run=client -oyaml | k neat > ./k8s/deployment.yaml
# k create service --image vitorcostasilva/app-prova:3.0 app-prova --dry-run=client -oyaml | k neat > ./k8s/deployment.yaml
# k apply -f ./k8s/service.yaml
# k run --image alpine:3.14 --rm -it demo sh   (apk add curl)
# curl http://app-prova.default.svc.cluster.local:8081
# k port-forward app-prova-6dfff99c4d-2c45l 8081:8081
# k port-forward app-prova-6dfff99c4d-2c45l 8080:8080
# k port-forward db-prova-7495b4d54b-rpfhc 5432:5432
# k delete deploy app-prova