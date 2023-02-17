#!/bin/bash

## docker image build and push
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin $1
docker build -t $1/rearc-quest:latest
docker push $1/rearc-quest:latest

