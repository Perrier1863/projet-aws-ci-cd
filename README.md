# Projet d'Infrastructure AWS avec Terraform

## Introduction

Ce projet Terraform permet de configurer un environnement complet de réseau sur AWS depuis Jenkins en utilisant des templates. 

Le template projet inclut la mise en place d'un VPC, de 4 sous-réseaux (1 public, 3 privés), d'une passerelles Internet, des tables de routage, et de 6 instances avec différents rôles tels que 3 machines Web (subnets privés), Admin, Public, et Squid dans un subnet public, et des groupes de sécurité avec des régles d'entrée et de sortie.

## Utilisation

### Prérequis

1. Assurez-vous que Terraform et Jenkins sont installés.
2. Configurez vos identifiants AWS en utilisant le CLI AWS (`aws configure`), ou par modifier le fichier `/var/jenkins_home/.aws/credentials`
3. Clonez ce Repo.

### Étapes Jenkins
1. Pour chaque script dans le dossier /Jenkins/ créer un job avec les propres variables et scripts.

2. Pour lancer un job cliquez `Build with parameters` et renseignez les paramètres que vous voulez (choisir template et nommer le projet).

3. Lancer le Job en cliquant `Build`.
### Étapes Terraform

1. Dans les fichiers du repo, copier le dossier `Terraform` vers `/var/jenkins_home/`.

2. Si vous voulez changer la région du déploiement :
   `sed -i 's/us-east-1/{ICI-VOTRE-REGION}/g' /var/jenkins_home/Terraform/TEMPLATES/{TEMPLATE_NAME}/main.tf`


Exemple :
```bash
cp -r Terraform/ /var/jenking_home/

sed -i 's/us-east-1/eu-west-1/g' /var/jenkins_home/Terraform/TEMPLATES/PROJET/main.tf
```

## Ressources Expliquées

### Partie Réseai

- **aws_vpc.INFRANAME-VPC-ABG** : Virtual Private Cloud pour isoler le réseau.
- **aws_subnet** (privé): Sous-réseaux pour isoler les machines web.
-  **aws_subnet** (public): Sous-réseaux ou mettre les machines qui gèrent l'accés au serveurs web.
- **aws_internet_gateway.INFRANAME-IGW-ABG** : Fournit un accès public à Internet pour le VPC.
- **aws_route_table** : Tables de routage pour gérer le trafic entre les sous-réseaux.

### Groupes de Sécurité

- **aws_security_group.INFRANAME-SG-PUBLIC-ABG** : Groupe de sécurité pour l'instance du `haproxy`.
- **aws_security_group.INFRANAME-SG-SQUID-ABG** : Groupe de sécurité pour l'instance `Squid`.
- **aws_security_group.INFRANAME-SG-ADMIN-ABG** : Groupe de sécurité pour la machine `Admin`.
- **aws_security_group.INFRANAME-SG-WEB-ABG** : Groupe de sécurité pour les instances `web`.

### Instances

- **aws_instance.INFRANAME-INSTANCE-SQUID-ABG** : Instance exécutant un proxy `Squid` pour gérer les connexions sortantes.
- **aws_instance.INFRANAME-INSTANCE-PUBLIC-ABG** : Instance exécutant un reverse proxy `haproxy`.
- **aws_instance.INFRANAME-INSTANCE-ADMIN-ABG** : Instance administrative pour la gestion et accés `SSH`.
- **aws_instance.INFRANAME-INSTANCE-WEB-A/B/C-ABG** : Instances web derrière le proxy.

### Données Utilisateur
- `web.sh` : Script pour l'installation des serveurs web `httpd` et leurs attachement au `Squid`.
- `squid.sh` : Script pour l'installation du proxy `squid`, et ca configuration.
- `rproxy.tpl` : Script pour l'installation du reverse proxy `haproxy` et la configuration pour qu'il fait du round-robin vers les 3 serveurs web.

---
