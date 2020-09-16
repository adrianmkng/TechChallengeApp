#!/usr/bin/env bash

set -x

stack_name=techchallenge-stack 
ami_id=$1

if ! aws cloudformation describe-stacks --region $AWS_DEFAULT_REGION --stack-name $stack_name; then
  aws cloudformation create-stack \
    --stack-name $stack_name \
    --template-body file://techchallenge-cf.json \
    --parameters ParameterKey="DBUser",ParameterValue="${DB_USER}" \
      ParameterKey="DBPassword",ParameterValue="${DB_PASSWORD}" \
      ParameterKey="AmiId",ParameterValue="${ami_id}"
else
  aws cloudformation update-stack 
    --template-body file://techchallenge-cf.json \
    --parameters ParameterKey="DBUser",ParameterValue="${DB_USER}" \
      ParameterKey="DBPassword",ParameterValue="${DB_PASSWORD}" \
      ParameterKey="AmiId",ParameterValue="${ami_id}"
fi
