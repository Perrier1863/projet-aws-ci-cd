#!/bin/bash

export HTTP_PROXY=http://${SQUID_IP}:3128
export HTTPS_PROXY=http://${SQUID_IP}:3128

yum update
yum install -y httpd
systemctl enable --now  httpd
