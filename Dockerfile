# Imagem base
FROM python:3.11-slim-bookworm AS base

WORKDIR /app

# Dependências do sistema (somente o essencial)
RUN apt-get update && apt-get install -y --no-install-recommends \
    gcc \
    && rm -rf /var/lib/apt/lists/*

# Copiar requirements primeiro (melhora cache)
COPY requirements.txt .

# Instalar dependências
RUN pip install --no-cache-dir -r requirements.txt

# Copiar código da aplicação
COPY . .

# Expor porta
EXPOSE 8000

# Rodar aplicação
CMD ["sh", "-c", "mkdir -p /app/db && uvicorn app:app --host 0.0.0.0 --port 8000"]