🌥️ Cloud Native Calculator – Projet Cloud & Virtualisation
Taher BAZZI • Mohamed Amine NAMOUCHI • Faniry ANDRIAMASINORO

✨ Présentation

Bienvenue dans notre projet Cloud Native Calculator, une application distribuée pensée pour illustrer une architecture cloud moderne : microservices, messagerie, cache, et déploiement automatisé.

L’objectif est simple : proposer une calculatrice capable d’effectuer les opérations essentielles (+ / − / × / ÷), tout en mettant en pratique une approche Cloud Native : déploiement reproductible, services découplés et infrastructure scalable.

🧩 Vue d’ensemble de l’architecture

Notre solution repose sur plusieurs composants qui coopèrent entre eux :

Frontend : interface web pour saisir une opération et consulter le résultat.

API (Backend) : reçoit les requêtes, valide les opérations et gère l’accès aux résultats.

RabbitMQ : file de messages assurant une communication asynchrone entre l’API et le traitement.

Consumer : récupère les messages, exécute le calcul et publie le résultat.

Redis : stockage rapide des résultats (cache / persistance courte) pour améliorer les performances.

Infrastructure / Déploiement : provisionnée avec Terraform et orchestrée par Kubernetes.

🎯 Objectifs techniques

Ce projet nous a permis de travailler sur :

🏗️ Infrastructure as Code (IaC) avec Terraform (création des ressources cloud)

☸️ Orchestration Kubernetes (déploiements, services, montée en charge)

✉️ Communication asynchrone via RabbitMQ

⚡ Optimisation et rapidité d’accès grâce à Redis

🧱 Séparation des responsabilités entre frontend, API et worker (consumer)

🤝 Travail d’équipe

Nous avons construit le projet en mode collaboratif, en répartissant les tâches selon les compétences et en intégrant régulièrement :

Taher BAZZI : mise en place et automatisation de l’infrastructure Terraform

Mohamed Amine NAMOUCHI : 

Faniry ANDRIAMASINORO :  



✅ Pré-requis

Pour exécuter le projet en local ou sur un cluster :

🐳 Docker

☸️ Kubernetes (minikube ou cluster distant)

🌍 Terraform

💻 Node.js (frontend)

🐍 Python (backend + consumer)


⭐ Points forts

➕➖✖️➗ Opérations principales couvertes

⚙️ Traitement asynchrone (API découplée du calcul)

⚡ Résultats rapides via cache Redis

🧱 Architecture modulaire, prête à évoluer (scalabilité Kubernetes)

👥 Auteurs

Taher BAZZI

Mohamed Amine NAMOUCHI

Faniry ANDRIAMASINORO