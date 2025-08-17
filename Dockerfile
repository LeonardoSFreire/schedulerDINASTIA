# Usar imagem Python 3.11 slim
FROM python:3.11-slim

# Definir diretório de trabalho
WORKDIR /app

# Copiar requirements primeiro para melhor cache
COPY requirements.txt .

# Instalar dependências Python
RUN pip install --no-cache-dir -r requirements.txt

# Copiar código da aplicação
COPY scheduler_api.py .
COPY .env .

# Expor porta 8000
EXPOSE 8000

# Executar a aplicação
CMD ["python", "scheduler_api.py"]