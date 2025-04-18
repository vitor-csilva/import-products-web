VERSION=31.0

build:
# @cd backend; ./cron.sh; cd ..
# export DOCKER_DEFAULT_PLATFORM=linux/amd64
	@docker build -t vitorcostasilva/import-products .

build2:
	@docker build --platform linux/amd64 -t vitorcostasilva/import-products:$(VERSION) .
	@make push

push:
	@docker push vitorcostasilva/import-products:$(VERSION)

run:
	@docker run -d -p 8080:8080 -p 8081:8081 --name import-products vitorcostasilva/import-products

compose:
# @cd backend; ./cron.sh; cd ..
	@docker compose build
	@docker compose up

helm:
	@helm install import-products ./k8s/helm/import-products -f ./k8s/helm/import-products/values.yaml -n import-products --create-namespace

helm-upgrade:
	@helm upgrade import-products ./k8s/helm/import-products -f ./k8s/helm/import-products/values.yaml -n import-products

helm-package:
	@helm package k8s/helm/import-products -d k8s/helm/import-products/charts
	@helm repo index k8s/helm/import-products/charts --url https://raw.githubusercontent.com/vitor-csilva/importacao-produtos-web/helm-repo/k8s/helm/import-products/charts