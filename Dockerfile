FROM debian:stable-slim

#Criando um diretório específico dentro do container para melhor organização
WORKDIR /app

#Definição do Time Zone dentro do container conforme o BD, pode ser utilizado outras opções como: TZ="Etc/UTC"
ENV DEBIAN_FRONTEND=noninteractive TZ="America/Sao_Paulo"

#Instalando todas as ferramentas e dependências necessárias
RUN apt-get update && apt-get install -y \
    sudo \
    python3 python3-pip python3-venv \
    nodejs npm \
    curl lsof nano cron \
    && rm -rf /var/lib/apt/lists/*

#Copiando os principais arquivos para execução do projeto
COPY backend ./backend
COPY frontend ./frontend

#Virtualenv evita o bloqueio PEP 668 do pip no Python do sistema
RUN python3 -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

#Instalando dependências necessárias
RUN pip install --no-cache-dir -r ./backend/requirements.txt
RUN cd frontend && npm install && npm install dotenv

#Expondo a porta de comunicação do container para acesso ao frontend e backend
EXPOSE 8080 8081

#Ao executar o container serão instânciados o backend e frontend
CMD ["sh", "-c", "cd /app/backend && ./start.sh && cd /app/frontend && npm run serve"]
