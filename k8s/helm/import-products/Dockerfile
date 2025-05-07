# Dockerfile responsavel por empurrar os templates do helm para o repositorio.
FROM alpine/helm:3.17.2

# Utilizar os args dentro de algum pipeline futuramente. 
# ARG TAG=2.0.0
ARG REPOSITORY_NAME=helm-import-products

ENV REPO_URL=registry-1.docker.io
ENV REPO_USERNAME=vitorcostasilva
ENV REPO_PASSWORD=${{ env.REPO_PASSWORD }}

# RUN helm registry login ${REPO_URL} -u ${REPO_USERNAME} -p ${REPO_PASSWORD}

RUN echo ${REPO_PASSWORD} | helm registry login registry-1.docker.io -u ${REPO_USERNAME} --password-stdin

WORKDIR /charts

COPY k8s/helm/import-products/templates templates/
COPY k8s/helm/import-products/Chart.yaml .

RUN helm dependency update .
RUN sed -i "s/0.1.0/${TAG}/g" Chart.yaml
RUN sed -i "s/name: import-products/name: ${REPOSITORY_NAME}/" Chart.yaml

RUN helm package . --destination generated/
RUN ls generated/${REPOSITORY_NAME}-*.tgz | xargs -i helm push {} oci://${REPO_URL}/${REPO_USERNAME}