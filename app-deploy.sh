#!/bin/bash

## docker image build and push

image_val="$1/rearc-quest:latest"
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin $1
docker build -t $image_val .
#docker push $1/rearc-quest:v1

current_tag=`aws ecr list-images --repository-name rearc-quest | jq '.imageIds[].imageTag' | tail -1 | tr -d '"v"'`
echo "Current tag is $current_tag, incrementing to next version"
new_tag_version=$((current_tag+1))
echo $new_tag_version
docker tag "$image_val" "$1/rearc-quest:v$new_tag_version"
docker push "$1/rearc-quest:v$new_tag_version"

## yq to update hte deployment file ##

## set kubeconfig and deploy k8s resources
export KUBECONFIG=~/.kube/config
kubectl apply -f k8s/external-dns/*
kubectl apply -f k8s/alb-ingress/*
kubectl apply -f k8s/appyamls/*

