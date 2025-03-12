FROM debian:bullseye-slim

#Criando um diretório específico dentro do container para melhor organização
WORKDIR /app

#Definição do Time Zone dentro do container conforme o BD, pode ser utilizado outras opções como: TZ="Etc/UTC"
ENV DEBIAN_FRONTEND=noninteractive TZ="America/Sao_Paulo"

#Instalando todas as ferramentas e dependências necessárias
RUN apt-get update && apt-get install -y \
    sudo \
    python3 python3-pip \
    nodejs npm \
    curl lsof nano cron \
    && rm -rf /var/lib/apt/lists/*

#Copiando os principais arquivos para execução do projeto
COPY backend ./backend
COPY frontend ./frontend

#Instalando dependências necessárias
RUN pip install -r ./backend/requirements.txt
RUN cd frontend; npm install; npm install dotenv

#Expondo a porta de comunicação do container para acesso ao frontend e backend
EXPOSE 8080 8081

#Ao executar o contianer serão instânciados o backend e frontend
CMD cd /app/backend && ./start.sh && \
    cd /app/frontend && npm run serve

# CMD cd /app/frontend && nohup npm run serve > output.log 2>&1 && \
#     cd /app/backend && ./start.sh
