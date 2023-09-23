# Projet d'Infrastructure AWS avec Terraform

## Introduction

Ce projet Terraform permet de configurer un environnement complet de réseau sur AWS depuis Jenkins en utilisant des templates. 

Le template projet inclut la mise en place d'un VPC, de 4 sous-réseaux (1 public, 3 privés), d'une passerelles Internet, des tables de routage, et de 6 instances avec différents rôles tels que 3 machines Web (subnets privés), Admin, Public, et Squid dans un subnet public, et des groupes de sécurité avec des régles d'entrée et de sortie.

## Utilisation

### Prérequis

1. Assurez-vous que Terraform, Jenkins et Git sont installés.
2. Configurez vos identifiants AWS en utilisant le CLI AWS (`aws configure`), ou en modifiant le fichier `/var/jenkins_home/.aws/credentials`
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
### Git en local
On commence par lui indiquer les fichiers qu'il doit ignorer grâce à un  .gitignore pour éviter des fichiers volumineux inutiles :
```
*/.terraform
*/.terraform.lock.hcl
```
On intialise git dans le repertoire que l'on veut versionner : 
```bash
git init
```
On indique à git qu'il doit gèrer les version de l'ensemble du repertoire actuel :

```bash
git add .
```
On effectue un premier commit :
```bash
git commit -a -m "premier commit"
```
On selectionne la branche master pour git :
```bash
git branch -M master
```

## Ressources Expliquées

### Partie Réseau

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
- `web.sh` : Script pour l'installation des serveurs web `httpd` et leurs attachements au `Squid`.
- `squid.sh` : Script pour l'installation du proxy `squid`, et sa configuration.
- `rproxy.tpl` : Script pour l'installation du reverse proxy `haproxy` et la configuration pour qu'il fait du round-robin vers les 3 serveurs web.

---
