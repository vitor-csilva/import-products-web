build:
# @cd backend; ./cron.sh; cd ..
# export DOCKER_DEFAULT_PLATFORM=linux/amd64
	@docker build -t vitorcostasilva/import-products .

run:
	@docker run -d -p 8080:8080 -p 8081:8081 --name import-products vitorcostasilva/import-products

compose:
# @cd backend; ./cron.sh; cd ..
	@docker compose build
	@docker compose up