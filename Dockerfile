FROM debian:bullseye-slim

#Criando um diretório específico dentro do container para melhor organização
WORKDIR /app

#Definição do Time Zone dentro do container conforme o BD, pode ser utilizado outras opções como: TZ="Etc/UTC"
ENV DEBIAN_FRONTEND=noninteractive TZ="America/Sao_Paulo"

#Instalando todas as ferramentas e dependências necessárias
RUN apt-get update && \
    apt-get install sudo \
    python3 python3-pip nodejs npm \
    curl lsof nano cron -y

#Copiando os principais arquivos para execução do projeto
COPY backend ./backend
COPY frontend ./frontend

#Removendo os arquivos *.csv de dentro da pasta de uploads para ter uma imagem mais reduzida utilizando o cron
## OBS: Cron Será adicionado ao Kubernetes
# RUN cd backend; ./cron.sh; cd /app

#Adicionando o cron para ser executado a cada 5 minutos
## OBS: Cron Será adicionado ao Kubernetes
# RUN echo "*/5 * * * * root /bin/bash /app/backend/cron.sh" > /etc/cron.d/cron_app_prova

#Instalando dependências necessárias
RUN pip install -r ./backend/requirements.txt
RUN cd frontend; npm install; npm install dotenv

#Expondo a porta de comunicação do container para acesso ao frontend e backend
EXPOSE 8080 8081

#Ao executar o contianer serão instânciados o backend e frontend
CMD cd /app/backend && ./start.sh && \
    cron && \
    cd /app/frontend && npm run serve

# CMD cd /app/frontend && nohup npm run serve > output.log 2>&1 && \
#     cd /app/backend && ./start.sh
