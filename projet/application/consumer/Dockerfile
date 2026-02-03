# application/consumer/Dockerfile
FROM python:3.9-slim

# Définir les variables d'environnement
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Créer un utilisateur non-root
RUN useradd -m -u 1001 worker && \
    mkdir -p /app && \
    chown -R worker:worker /app

WORKDIR /app

# Copier les dépendances
COPY --chown=worker:worker requirements.txt .

# Installer les dépendances
RUN apt-get update && \
    apt-get install -y --no-install-recommends gcc && \
    pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt && \
    apt-get purge -y gcc && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/*

# Copier le code
COPY --chown=worker:worker . .

# Changer d'utilisateur
USER worker

# Commande pour démarrer le consumer
CMD ["python", "consumer.py"]