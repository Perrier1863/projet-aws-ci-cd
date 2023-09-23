terraform {
        required_providers {
                aws = {
                        source  = "hashicorp/aws"
                }
        }
}
provider "aws" {
        region = "us-east-1"
}
#Création VPC
resource "aws_vpc" "INFRANAME-VPC-ABG" {
        cidr_block = "10.0.0.0/16"
        tags = {
                Name = "INFRANAME-VPC-ABG"
        }
}
### Création des subnets ###

# Subnet Public
resource "aws_subnet" "INFRANAME-SUBNET-PUBLIC-ABG" {
        vpc_id = "${aws_vpc.INFRANAME-VPC-ABG.id}"
        cidr_block = "10.0.1.0/24"
        tags = {
                Name = "INFRANAME-SUBNET-PUBLIC-ABG"
        }
}
#Subnet Web A
resource "aws_subnet" "INFRANAME-SUBNET-WEB-A-ABG" {
        vpc_id = "${aws_vpc.INFRANAME-VPC-ABG.id}"
        cidr_block = "10.0.2.0/24"
        tags = {
                Name = "INFRANAME-SUBNET-WEB-A-ABG"
        }
}
#Subnet Web B
resource "aws_subnet" "INFRANAME-SUBNET-WEB-B-ABG" {
        vpc_id = "${aws_vpc.INFRANAME-VPC-ABG.id}"
        cidr_block = "10.0.3.0/24"
        tags = {
                Name = "INFRANAME-SUBNET-WEB-B-ABG"
        }
}
#Subnet Web C
resource "aws_subnet" "INFRANAME-SUBNET-WEB-C-ABG" {
        vpc_id = "${aws_vpc.INFRANAME-VPC-ABG.id}"
        cidr_block = "10.0.4.0/24"
        tags = {
                Name = "INFRANAME-SUBNET-WEB-C-ABG"
        }
}
# Création de l'internet gateway 
resource "aws_internet_gateway" "INFRANAME-IGW-ABG" {
        tags = {
                Name = "INFRANAME-IGW-ABG"
        }
}
# Attache de l'internet gateway au VPC 
resource "aws_internet_gateway_attachment" "INFRANAME-IGW-ATTACH-ABG" {
        vpc_id = "${aws_vpc.INFRANAME-VPC-ABG.id}"
        internet_gateway_id = "${aws_internet_gateway.INFRANAME-IGW-ABG.id}"
}
# Création de la table de routage pour le réseau public
resource "aws_route_table" "INFRANAME-RTB-PUBLIC-ABG" {
        vpc_id = "${aws_vpc.INFRANAME-VPC-ABG.id}"
        route {
                cidr_block = "0.0.0.0/0"
                gateway_id = "${aws_internet_gateway.INFRANAME-IGW-ABG.id}"
        }
        tags = {
                Name = "INFRANAME-RTB-PUBLIC-ABG"
        }
}
resource "aws_route_table" "INFRANAME-RTB-WEB-ABG" {
        vpc_id = "${aws_vpc.INFRANAME-VPC-ABG.id}"
        route {
                cidr_block = "0.0.0.0/0"
                gateway_id = "${aws_internet_gateway.INFRANAME-IGW-ABG.id}"
        }
        tags = {
                Name = "INFRANAME.RTB-WEB-ABG"
        }
}
# Association de la table de routage au subnet web A
resource "aws_route_table_association" "INFRANAME-RTB-WEB-A-ASSOC-ABG" {
        subnet_id = "${aws_subnet.INFRANAME-SUBNET-WEB-A-ABG.id}"
        route_table_id = "${aws_route_table.INFRANAME-RTB-WEB-ABG.id}"
}
# Association de la table de routage au subnet web B
resource "aws_route_table_association" "INFRANAME-RTB-WEB-B-ASSOC-ABG" {
        subnet_id = "${aws_subnet.INFRANAME-SUBNET-WEB-B-ABG.id}"
        route_table_id = "${aws_route_table.INFRANAME-RTB-WEB-ABG.id}"
}
# Association de la table de routage au subnet web C
resource "aws_route_table_association" "INFRANAME-RTB-WEB-C-ASSOC-ABG" {
        subnet_id = "${aws_subnet.INFRANAME-SUBNET-WEB-C-ABG.id}"
        route_table_id = "${aws_route_table.INFRANAME-RTB-WEB-ABG.id}"
}
# Association de la table de routage au subnet web Public
resource "aws_route_table_association" "INFRANAME-RTB-PUBLIC-ASSOC-ABG" {
        subnet_id = "${aws_subnet.INFRANAME-SUBNET-PUBLIC-ABG.id}"
        route_table_id = "${aws_route_table.INFRANAME-RTB-PUBLIC-ABG.id}"
}
# Création du GRP-SECU PUBLIC
resource "aws_security_group" "INFRANAME-SG-PUBLIC-ABG" {
        vpc_id = "${aws_vpc.INFRANAME-VPC-ABG.id}"
        ingress {
                from_port = "80"
                to_port = "80"
                protocol = "tcp"
                cidr_blocks = ["0.0.0.0/0"]
        }
        egress {
                from_port = "0"
                to_port = "0"
                protocol = "-1"
                cidr_blocks = ["0.0.0.0/0"]
        }
        tags = {
                Name = "INFRANAME-SG-PUBLIC-ABG"
        }
}
# Création du GRP-SECU SQUID
resource "aws_security_group" "INFRANAME-SG-SQUID-ABG" {
        vpc_id = "${aws_vpc.INFRANAME-VPC-ABG.id}"
        ingress {
                from_port = "80"
                to_port = "80"
                protocol = "tcp"
                cidr_blocks = ["0.0.0.0/0"]
        }
        ingress {
                from_port = "3128"
                to_port = "3128"
                protocol = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
        }
        egress {
                from_port = "0"
                to_port = "0"
                protocol = "-1"
                cidr_blocks = ["0.0.0.0/0"]
        }
        tags = {
                Name = "INFRANAME-SG-SQUID-ABG"
        }
}
# Création du GRP-SECU Admin
resource "aws_security_group" "INFRANAME-SG-ADMIN-ABG" {
        vpc_id = "${aws_vpc.INFRANAME-VPC-ABG.id}"
        ingress {
                from_port = "22"
                to_port = "22"
                protocol = "tcp"
                cidr_blocks = ["0.0.0.0/0"]
        }
        ingress {
                from_port = "80"
                to_port = "80"
                protocol = "tcp"
                cidr_blocks = ["0.0.0.0/0"]
        }
        egress {
                from_port = "0"
                to_port = "0"
                protocol = "-1"
                cidr_blocks = ["0.0.0.0/0"]
        }
        tags = {
                Name = "INFRANAME-SG-ADMIN-ABG"
        }
}
# Création du GRP-SECU WEB
resource "aws_security_group" "INFRANAME-SG-WEB-ABG" {
        vpc_id = "${aws_vpc.INFRANAME-VPC-ABG.id}"
        ingress {
                from_port = "22"
                to_port = "22"
                protocol = "tcp"
                security_groups = ["${aws_security_group.INFRANAME-SG-ADMIN-ABG.id}"]
        }
        ingress {
                from_port = "80"
                to_port = "80"
                protocol = "tcp"
                security_groups = ["${aws_security_group.INFRANAME-SG-PUBLIC-ABG.id}"]
        }
        ingress {
                from_port = "3128"
                to_port = "3128"
                protocol = "tcp"
                security_groups = ["${aws_security_group.INFRANAME-SG-SQUID-ABG.id}"]
        }
        egress {
                from_port = "0"
                to_port = "0"
                protocol = "-1"
                cidr_blocks = ["0.0.0.0/0"]
        }
        tags = {
                Name = "INFRANAME-SG-WEB-ABG"
        }
}
# INSTANCE SQUID
resource "aws_instance" "INFRANAME-INSTANCE-SQUID-ABG" {
        subnet_id = "${aws_subnet.INFRANAME-SUBNET-PUBLIC-ABG.id}"
        instance_type = "t2.micro"
        ami = "ami-03a6eaae9938c858c"
        key_name = "ABG-KEYPAIR"
        vpc_security_group_ids = ["${aws_security_group.INFRANAME-SG-SQUID-ABG.id}"]
        associate_public_ip_address = true
        tags = {
                Name = "INFRANAME-INSTANCE-SQUID-ABG"
        }
        user_data = file("squid.sh")
}
# INSTANCE PROXY
resource "aws_instance" "INFRANAME-INSTANCE-PUBLIC-ABG" {
        subnet_id = "${aws_subnet.INFRANAME-SUBNET-PUBLIC-ABG.id}"
        instance_type = "t2.micro"
        ami = "ami-03a6eaae9938c858c"
        key_name = "ABG-KEYPAIR"
        vpc_security_group_ids = ["${aws_security_group.INFRANAME-SG-PUBLIC-ABG.id}"]
        associate_public_ip_address = true
        tags = {
                Name = "INFRANAME-INSTANCE-PUBLIC-ABG"
        }
	user_data = "${templatefile("rproxy.tpl", { WEB_IP_A = "${aws_instance.INFRANAME-INSTANCE-WEB-A-ABG.private_ip}", WEB_IP_B = "${aws_instance.INFRANAME-INSTANCE-WEB-B-ABG.private_ip}", WEB_IP_C = "${aws_instance.INFRANAME-INSTANCE-WEB-C-ABG.private_ip}"  })}"
}
resource "aws_instance" "INFRANAME-INSTANCE-ADMIN-ABG" {
        subnet_id = "${aws_subnet.INFRANAME-SUBNET-PUBLIC-ABG.id}"
        instance_type = "t2.micro"
        ami = "ami-03a6eaae9938c858c"
        key_name = "ABG-KEYPAIR"
        vpc_security_group_ids = ["${aws_security_group.INFRANAME-SG-ADMIN-ABG.id}"]
        associate_public_ip_address = true
        tags = {
                Name = "INFRANAME-INSTANCE-ADMIN-ABG"
        }
}
# INSTANCE WEB A
resource "aws_instance" "INFRANAME-INSTANCE-WEB-A-ABG" {
        subnet_id = "${aws_subnet.INFRANAME-SUBNET-WEB-A-ABG.id}"
        instance_type = "t2.micro"
        ami = "ami-03a6eaae9938c858c"
        key_name = "ABG-KEYPAIR"
        vpc_security_group_ids = ["${aws_security_group.INFRANAME-SG-WEB-ABG.id}"]
        associate_public_ip_address = false
        tags = {
                Name = "INFRANAME-INSTANCE-WEB-A"
        }
        user_data = "${templatefile("web.sh", { SQUID_IP = "${aws_instance.INFRANAME-INSTANCE-SQUID-ABG.private_ip}" })}"

}
# INSTANCE WEB B
resource "aws_instance" "INFRANAME-INSTANCE-WEB-B-ABG" {
        subnet_id = "${aws_subnet.INFRANAME-SUBNET-WEB-B-ABG.id}"
        instance_type = "t2.micro"
        ami = "ami-03a6eaae9938c858c"
        key_name = "ABG-KEYPAIR"
        vpc_security_group_ids = ["${aws_security_group.INFRANAME-SG-WEB-ABG.id}"]
        associate_public_ip_address = false
        tags = {
                Name = "INFRANAME-INSTANCE-WEB-B"
        }
        user_data = "${templatefile("web.sh", { SQUID_IP = "${aws_instance.INFRANAME-INSTANCE-SQUID-ABG.private_ip}" })}"

}
# INSTANCE WEB C
resource "aws_instance" "INFRANAME-INSTANCE-WEB-C-ABG" {
        subnet_id = "${aws_subnet.INFRANAME-SUBNET-WEB-C-ABG.id}"
        instance_type = "t2.micro"
        ami = "ami-03a6eaae9938c858c"
        key_name = "ABG-KEYPAIR"
        vpc_security_group_ids = ["${aws_security_group.INFRANAME-SG-WEB-ABG.id}"]
        associate_public_ip_address = false
        tags = {
                Name = "INFRANAME-INSTANCE-WEB-C"
        }
        user_data = "${templatefile("web.sh", { SQUID_IP = "${aws_instance.INFRANAME-INSTANCE-SQUID-ABG.private_ip}" })}"
}
