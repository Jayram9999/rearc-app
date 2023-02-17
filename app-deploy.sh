#!/bin/bash

## docker image build and push
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin $1
docker build -t 508460187788.dkr.ecr.us-east-1.amazonaws.com/rearc-quest:latest
docker push 508460187788.dkr.ecr.us-east-1.amazonaws.com/rearc-quest:latest

