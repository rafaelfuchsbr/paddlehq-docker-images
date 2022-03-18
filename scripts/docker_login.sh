#!/bin/bash

registry="$1"
echo "Docker login into [${registry}]"
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin ${registry}
echo ""

