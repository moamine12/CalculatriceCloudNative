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

#Construire les images pour chaque microservice :
# Backend
docker build -t backend ./application/Backend
# Frontend
docker build -t frontend ./application/Frontend
# Consumer
docker build -t worker ./application/consumer
près authentification avec gcloud auth configure-docker, ajouter un tag pour chaque image avant de pousser :

# Frontend
docker tag frontend:latest europe-west1-docker.pkg.dev/polytech-dijon/polytech-dijon/frontend-2026:namouchi-bazzi-andriamasinoro
docker push europe-west1-docker.pkg.dev/polytech-dijon/polytech-dijon/frontend-2026:namouchi-bazzi-andriamasinoro
# Backend
docker tag backend:latest europe-west1-docker.pkg.dev/polytech-dijon/polytech-dijon/backend-2026:namouchi-bazzi-andriamasinoro
docker push europe-west1-docker.pkg.dev/polytech-dijon/polytech-dijon/backend-2026:namouchi-bazzi-andriamasinoro
# consumer
docker tag consumer:latest europe-west1-docker.pkg.dev/polytech-dijon/polytech-dijon/consumer-2026:namouchi-bazzi-andriamasinoro
docker push europe-west1-docker.pkg.dev/polytech-dijon/polytech-dijon/consumer-2026:namouchi-bazzi-andriamasinoro
# Lancer le backend
cd backend
pip install -r requirements.txt
python app.py

# Lancer le consumer
cd consumer
pip install -r requirements.txt
python consumer.py
