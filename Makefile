build:
	@cd backend; ./cron.sh; cd ..
	@docker build -t app-prova .

run:
	@docker run -d -p 8080:8080 -p 8081:8081 --name app-prova app-prova

compose:
	@cd backend; ./cron.sh; cd ..
	@docker compose build
	@docker compose up