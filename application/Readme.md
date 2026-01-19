# Application Calculatrice

## Microservices
- **Frontend** : Interface utilisateur (HTML/CSS/JS)
- **Backend** : API Flask
- **Consumer** : Traitement des calculs

## Développement local
```bash
# Lancer les services
docker run -p 6379:6379 --name redis --rm redis
docker run -p 5672:5672 -p 15672:15672 --name rabbitmq --rm rabbitmq:3-management

# Lancer le backend
cd backend
pip install -r requirements.txt
python app.py

# Lancer le consumer
cd consumer
pip install -r requirements.txt
python consumer.py