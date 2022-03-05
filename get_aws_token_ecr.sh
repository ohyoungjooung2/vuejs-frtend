#!/usr/bin/env bash
#This script is from stackexchange.com. Many thanks.
ACCOUNT=494307375889
REGION=ap-northeast-2
SECRET_NAME=${REGION}-ecr-registry
EMAIL=email@email.com
#
#
TOKEN=`aws ecr --region=$REGION get-authorization-token --output text \
    --query authorizationData[].authorizationToken | base64 -d | cut -d: -f2`
#
#  Create or replace registry secret
#
echo $PATH
$HOME/bin/kubectl delete secret --ignore-not-found $SECRET_NAME
$HOME/bin/kubectl create secret docker-registry $SECRET_NAME \
  --docker-server=https://${ACCOUNT}.dkr.ecr.${REGION}.amazonaws.com \
  --docker-username=AWS \
  --docker-password="${TOKEN}" \
  --docker-email="${EMAIL}" \
