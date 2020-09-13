#!/usr/bin/env bash

stack_name=techchallenge-stack 

if ! aws cloudformation describe-stacks --region $AWS_DEFAULT_REGION --stack-name $stack_name; then
  aws cloudformation create-stack --stack-name $stack_name --template-body file://techchallenge-cf.json --parameters ParameterKey="BuildBucket",ParameterValue="${BUILD_BUCKET}" ParameterKey="DBUser",ParameterValue="${DB_USER}" ParameterKey="DBPassword",ParameterValue="${DB_PASSWORD}"
else
  aws cloudformation update-stack --stack-name $stack_name --template-body file://techchallenge-cf.json --parameters ParameterKey="BuildBucket",ParameterValue="${BUILD_BUCKET}" ParameterKey="DBUser",ParameterValue="${DB_USER}" ParameterKey="DBPassword",ParameterValue="${DB_PASSWORD}"
fi
