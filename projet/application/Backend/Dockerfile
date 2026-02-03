# application/backend/Dockerfile
FROM python:3.9-slim

# Définir les variables d'environnement
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
ENV FLASK_APP=app.py
ENV FLASK_ENV=production

# Créer un utilisateur non-root pour la sécurité
RUN useradd -m -u 1000 appuser && \
    mkdir -p /app && \
    chown -R appuser:appuser /app

# Définir le répertoire de travail
WORKDIR /app

# Copier le fichier de dépendances d'abord (pour meilleur cache Docker)
COPY --chown=appuser:appuser requirements.txt .

# Installer les dépendances
RUN apt-get update && \
    apt-get install -y --no-install-recommends gcc && \
    pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt && \
    apt-get purge -y gcc && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/*

# Copier le code de l'application
COPY --chown=appuser:appuser . .

# Changer d'utilisateur
USER appuser

# Exposer le port
EXPOSE 5000

# Commande pour démarrer l'application
CMD ["python", "app.py"]