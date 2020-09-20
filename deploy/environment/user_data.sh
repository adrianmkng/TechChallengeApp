#!/bin/bash
sudo systemctl enable amazon-ssm-agent
sudo systemctl start amazon-ssm-agent
mkdir /app
cd /app
curl -Lo techchallenge.zip  https://github.com/servian/TechChallengeApp/releases/download/${app_version}/TechChallengeApp_${app_version}_linux64.zip
unzip techchallenge.zip

