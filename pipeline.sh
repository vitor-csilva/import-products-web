#!/bin/bash

#Realiza a build da imagem a partir do Dockerfile e disponibiliza o mesmo para o Docker hub
function _build () {
    echo -e "##### Build Dockerfile #####\n"
    cd backend; ./cron.sh; cd ..
    TAG=$(docker images --filter "reference=vitorcostasilva/app-prova:*" --format "{{.Tag}}" | sort -r | head -n 1)
    if [ -z "${TAG}" ]; then
        #echo "É Null"
        docker build -t vitorcostasilva/app-prova:1.0 .
    else
        #echo "Não é Null"
        # Utilizando o bc para realizar a soma
        TAG=$(echo "$TAG + 1.0" | bc)
        echo "Gerando versão: $TAG"
        docker build -t vitorcostasilva/app-prova:${TAG} .
    fi
}

function _get_nova_tag () {
    echo -e  "\n### Nova imagem gerada ####\n"
    docker images --filter "reference=vitorcostasilva/app-prova:$TAG"
    echo -e  "\n###########################\n"
}

#Verifica se a versão\tag a ser feito o push já existe no repositorio do Docker hub 
function _check_tag () {
    response=$(curl -s -o /dev/null -w "%{http_code}" "https://hub.docker.com/v2/repositories/vitorcostasilva/app-prova/tags/$TAG")
    if [ "$response" -eq 200 ]; then
        echo -e "\nA versão:$TAG da imagem já existe no Repositório do Docker Hub\n"
        exit 1
    else
        echo -e "\nCheck realizado a versao:$TAG não existe no Docker Hub\n"
    fi
}

#Realiza o push da imagem gerada para o Docker Hub
function _push_docker_hub () {
    _check_tag
    docker push vitorcostasilva/app-prova:$TAG
}

#Atualiza o deployment da aplicação para ultima versão da imagem gerada. 
function _att_tag_deployment () {
    export KUBECONFIG=./k8s/config
    kubectl set image deployment/app-prova app-prova=vitorcostasilva/app-prova:$TAG
}

_build
_get_nova_tag
_push_docker_hub
_att_tag_deployment