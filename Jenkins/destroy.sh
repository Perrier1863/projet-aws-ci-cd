#!/bin/bash

cd /var/jenkins_home/Terraform/INFRAS/${PROJECT_NAME}
terraform destroy --auto-approve -no-color
rm -r /var/jenkins_home/Terraform/INFRAS/${PROJECT_NAME}
cd /var/jenkins_home/Terraform/INFRAS
git commit -a -m "Destruction de l'infra :  ${PROJECT_NAME}"
exit