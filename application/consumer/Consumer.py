import pika
import redis
import json
import time
import os

print("🚀 Consumer de calculatrice démarré...")

# Configuration
REDIS_HOST = os.getenv('REDIS_HOST', 'localhost')
RABBITMQ_HOST = os.getenv('RABBITMQ_HOST', 'localhost')

# Connexion Redis
redis_client = redis.Redis(
    host=REDIS_HOST,
    port=6379,
    db=0,
    decode_responses=True
)

# Fonction de calcul (similaire à ton ancien Consumer.py)
def calculer(a, b, operateur):
    """Effectue un calcul simple"""
    try:
        a = float(a)
        b = float(b)
    except ValueError:
        return "Erreur: valeurs non numériques"
    
    if operateur == "+":
        return a + b
    elif operateur == "-":
        return a - b
    elif operateur == "*":
        return a * b
    elif operateur == "/":
        if b == 0:
            return "Erreur: division par zéro"
        return a / b
    else:
        return "Erreur: opérateur inconnu"

def traiter_calcul(ch, method, properties, body):
    """Traite un message de calcul"""
    try:
        message = json.loads(body)
        calc_id = message['id']
        a = message['a']
        b = message['b']
        op = message['op']
        
        print(f"📥 Calcul reçu: {calc_id} -> {a} {op} {b}")
        
        # Effectuer le calcul
        resultat = calculer(a, b, op)
        
        # Stocker le résultat dans Redis
        redis_client.setex(calc_id, 300, str(resultat))  # Expire après 5min
        
        print(f"✅ Calcul terminé: {calc_id} = {resultat}")
        
    except json.JSONDecodeError:
        print("❌ Message JSON invalide")
    except KeyError as e:
        print(f"❌ Champ manquant: {e}")
    except Exception as e:
        print(f"❌ Erreur: {e}")

def main():
    """Boucle principale du consumer"""
    while True:
        try:
            # Connexion RabbitMQ
            connection = pika.BlockingConnection(
                pika.ConnectionParameters(
                    host=RABBITMQ_HOST,
                    heartbeat=600
                )
            )
            channel = connection.channel()
            
            # Déclarer la queue
            channel.queue_declare(queue='calcul_queue', durable=True)
            
            # Configurer le consumer
            channel.basic_qos(prefetch_count=1)
            channel.basic_consume(
                queue='calcul_queue',
                on_message_callback=traiter_calcul,
                auto_ack=True
            )
            
            print("✅ Connecté à RabbitMQ. En attente de calculs...")
            channel.start_consuming()
            
        except pika.exceptions.AMQPConnectionError:
            print("❌ Impossible de se connecter à RabbitMQ. Reconnexion dans 5s...")
            time.sleep(5)
        except KeyboardInterrupt:
            print("\n👋 Arrêt du consumer...")
            break
        except Exception as e:
            print(f"❌ Erreur inattendue: {e}")
            time.sleep(5)

if __name__ == '__main__':
    main()