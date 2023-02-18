#!/bin/bash

## docker image build and push
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin $1
docker build -t $1/rearc-quest:latest
docker push $1/rearc-quest:latest

## set kubeconfig and deploy k8s resources

export KUBECONFIG=~/.kube/config
kubectl apply -f k8s/external-dns/*
kubectl apply -f k8s/alb-ingress/*
kubectl apply -f k8s/appyamls/*

