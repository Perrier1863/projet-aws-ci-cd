#!/bin/bash

REALWORKSPACE=/var/jenkins_home/Terraform
cd $REALWORKSPACE
cp -r TEMPLATES/${TEMPLATE} INFRAS/${PROJECT_NAME}
cd INFRAS/${PROJECT_NAME}
sed -i "s|INFRANAME|${PROJECT_NAME}|g" main.tf
terraform init -no-color
terraform apply --auto-approve -no-color
cd /var/jenkins_home/Terraform/INFRAS
git add ${PROJECT_NAME}
git commit -a -m "Création de l'infra : ${PROJECT_NAME}"
exit