from flask import Flask, request, jsonify, send_from_directory
import redis
import pika
import json
import uuid
import os
from flask_cors import CORS  # Pour éviter les erreurs CORS

app = Flask(__name__, static_folder='../Frontend', static_url_path='')
CORS(app)  # Active CORS pour le frontend

# Configuration (simple pour développement)
REDIS_HOST = os.getenv('REDIS_HOST', 'localhost')
RABBITMQ_HOST = os.getenv('RABBITMQ_HOST', 'localhost')

print(f"Connexion à Redis: {REDIS_HOST}")
print(f"Connexion à RabbitMQ: {RABBITMQ_HOST}")

# Initialisation Redis
redis_client = None
try:
    redis_client = redis.Redis(
        host=REDIS_HOST, 
        port=6379, 
        db=0,
        socket_connect_timeout=2,
        decode_responses=True  # Pour avoir des strings au lieu de bytes
    )
    redis_client.ping()
    print("✅ Redis connecté")
except Exception as e:
    print(f"❌ Erreur Redis: {e}")
    redis_client = None

# Initialisation RabbitMQ
channel = None
try:
    connection = pika.BlockingConnection(
        pika.ConnectionParameters(
            host=RABBITMQ_HOST,
            heartbeat=600
        )
    )
    channel = connection.channel()
    channel.queue_declare(queue='calcul_queue', durable=True)
    print("✅ RabbitMQ connecté")
except Exception as e:
    print(f"❌ Erreur RabbitMQ: {e}")
    channel = None

@app.route('/')
def home():
    return send_from_directory(app.static_folder, 'index.html')

@app.route('/api/calculate', methods=['POST'])
def calculate():
    """Reçoit un calcul et le met dans RabbitMQ"""
    if not redis_client or not channel:
        return jsonify({'error': 'Services non disponibles'}), 500
    
    try:
        data = request.json
        
        # Validation simple
        if not data or 'a' not in data or 'b' not in data or 'op' not in data:
            return jsonify({'error': 'Données manquantes'}), 400
        
        a = float(data['a'])
        b = float(data['b'])
        op = data['op']
        
        # Vérification opérateur valide
        if op not in ['+', '-', '*', '/']:
            return jsonify({'error': 'Opérateur invalide'}), 400
        
        # Création ID unique
        calc_id = str(uuid.uuid4())
        
        # Message pour RabbitMQ
        message = {
            'id': calc_id,
            'a': a,
            'b': b,
            'op': op
        }
        
        # Envoi à RabbitMQ
        channel.basic_publish(
            exchange='',
            routing_key='calcul_queue',
            body=json.dumps(message),
            properties=pika.BasicProperties(
                delivery_mode=2,  # Message persistant
            )
        )
        
        # Stocker dans Redis comme "en attente"
        redis_client.setex(calc_id, 300, 'pending')  # Expire après 5min
        
        print(f"📨 Calcul envoyé: {calc_id} -> {a} {op} {b}")
        
        return jsonify({
            'id': calc_id,
            'status': 'en_attente',
            'message': 'Calcul en cours de traitement'
        }), 202
        
    except ValueError:
        return jsonify({'error': 'Valeurs numériques invalides'}), 400
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/api/result/<calc_id>', methods=['GET'])
def get_result(calc_id):
    """Récupère le résultat d'un calcul"""
    if not redis_client:
        return jsonify({'error': 'Redis non disponible'}), 500
    
    try:
        result = redis_client.get(calc_id)
        
        if not result:
            return jsonify({'error': 'Calcul non trouvé'}), 404
        
        if result == 'pending':
            return jsonify({
                'status': 'pending',
                'message': 'Calcul en cours de traitement'
            }), 202
        
        # Résultat final
        return jsonify({
            'id': calc_id,
            'result': float(result),
            'status': 'completed'
        }), 200
        
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/api/health', methods=['GET'])
def health():
    """Endpoint de santé"""
    status = {
        'redis': 'ok' if redis_client else 'error',
        'rabbitmq': 'ok' if channel else 'error'
    }
    return jsonify(status), 200 if all(v == 'ok' for v in status.values()) else 503

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)