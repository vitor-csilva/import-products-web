VERSION=9.0

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