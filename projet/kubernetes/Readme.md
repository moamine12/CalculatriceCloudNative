Ce dossier contient les manifests nécessaires au déploiement de la solution sur le cluster.

1. Infrastructure (Middleware):
   kubectl apply -f rabbitmq/
   kubectl apply -f redis/

2. Services Applicatifs :
   kubectl apply -f backend/
   kubectl apply -f consumer/

3. Interface Utilisateur :
   kubectl apply -f frontend/

## Test et Validation

1. Vérification de l'état des ressources
Pods => 'Running' :
kubectl get pods -n namouchi-bazzi-andriamasinoro
kubectl svc -n namouchi-bazzi-andriamasinoro
kubectl get ingress -n namouchi-bazzi-andriamasinoro

2. Test d'accès au Frontend (Port-Forward)
Pour tester l'interface web sans IP publique :
kubectl port-forward -n namouchi-bazzi-andriamasinoro svc/frontend 8080:80

Ouvrir http://localhost:8080

3. Test de connectivité Backend -> RabbitMQ
Vérifiez dans les logs du backend :
kubectl logs -f deployment/backend -n namouchi-bazzi-andriamasinoro

4. Test du Consumer
Envoyez une requête via le frontend et vérifiez que le pod 'consumer' reçoit et traite bien le message :
kubectl logs -f deployment/consumer -n namouchi-bazzi-andriamasinoro

5. Test de l'interface RabbitMQ
Pour vérifier l'état des files d'attente (queues) :
kubectl port-forward -n namouchi-bazzi-andriamasinoro svc/rabbitmq 15672:15672
Accès sur : http://localhost:15672