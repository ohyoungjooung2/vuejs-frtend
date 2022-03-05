#!/usr/bin/env bash
KEY="$HOME/.ssh/id_rsa"
ST="-o StrictHostKeyChecking=no"
AWS_REGION="ap-northeast-2"
ACCOUNT="$ACCOUNT"
NAME="vuejs-frtend"

#Build app
#./mvnw clean install
#Execute aws acr token get script
. ./get_aws_token_ecr.sh
#KCTL=$(which kubectl)
echo 'TestingTesting'
echo "Delete latest local image first"
docker rm $ACCOUNT.dkr.ecr.ap-northeast-2.amazonaws.com/$NAME:latest
#Non tag or none name delete
docker image rm $(docker images | grep -i "<none>" | awk '{print $3}')

#Tag by date and HOur
TAG=$(date +%s)
docker build . -t $NAME:$TAG; docker images | grep $NAME
docker tag $NAME:$TAG $ACCOUNT.dkr.ecr.ap-northeast-2.amazonaws.com/$NAME:latest
docker image rm $(docker images | grep -i "<none>" | awk '{print $3}')

#Retage latest to today date and delete latest
#1. retag
MANIFEST=$(aws ecr batch-get-image --repository-name $NAME --image-ids imageTag=latest --output json | jq --raw-output '.images[0].imageManifest')
if [[ $MANIFEST != null ]]
then
   echo "MANIFEST IS $MANIFEST"
   echo "Delete just_previous tag image"
   aws ecr batch-delete-image \
       --repository-name $NAME\
       --image-ids imageTag=just_previous
   echo "deleted just_previous tag and retag latest to just_previous"
   aws ecr put-image --repository-name $NAME --image-tag "just_previous" --image-manifest "$MANIFEST"
   #Delete latest image
   aws ecr batch-delete-image \
       --repository-name $NAME\
       --image-ids imageTag=latest
   else
       echo "No MANIFEST OF LATEST"
fi


#Show ecr image lists and push
aws ecr list-images --repository-name $NAME;

#get token to push image
echo "Getting token"
aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $ACCOUNT.dkr.ecr.$AWS_REGION.amazonaws.com
docker push $ACCOUNT.dkr.ecr.ap-northeast-2.amazonaws.com/$NAME:latest
aws ecr list-images --repository-name $NAME;

#If docker build fails then exit!
if [[ $? -eq 0 ]]
then
	echo -e "\e[35m docker build success \e[00m"
else
	echo -e "\e[33m docker build failed \e[00m"
	exit 1
fi


echo "Kubectl check"
chk=$($HOME/bin/kubectl get node | grep -i ready > /dev/null 2>&1) 
echo $chk

if [[ $? != "0"   ]]
then
   echo "kubectl is no work exit!"
   exit 1
else
   echo "kubectl work ok"
fi
#
$HOME/bin/kubectl delete -f $NAME-dp.yaml
echo "Deployment of $NAME"
if [[ -e $NAME-dp.yaml ]]
then
	$HOME/bin/kubectl apply -f $NAME-dp.yaml
	sleep 3
	$HOME/bin/kubectl get po | grep -i $NAME | grep -v srv
else
	echo " $NAME-dp.yaml no exitst! exiitng!"
	exit 3
fi


##Default duration check time until service on.
#NOWTIME=$(date +%s)
##5 MINUTES
#TILTIME=300
#TILTIMECOMPLETE=$(($NOWTIME+$TILTIME))
#while true
#do
# ssh -i $KEY $ST -p 22 vagrant@10.1.0.2 'curl http://10.1.0.3:32339/demo/all'
# CHK
# ssh -i $KEY $ST -p 22 vagrant@10.1.0.2 'curl http://10.1.0.4:32339/demo/all'
# CHK
# ssh -i $KEY $ST -p 22 vagrant@10.1.0.2 'curl http://10.1.0.4:32339/demo/all'
# CHK
# CURRENTIME=$(date +%s)
# DURATION_SEC=$(($CURRENTIME-$NOWTIME))
# echo "DURATION_SEC=$DURATION_SEC"
# echo 
# #If current time unix epoch time is more than 5 minutes..since check service..then..stop..exit
# if [[ $CURRENTIME -ge $TILTIMECOMPLETE ]]
# then
#	 echo "Service wait time ends"
#	 echo "Deploy failed..:("
#	 exit 1
# fi
#done
