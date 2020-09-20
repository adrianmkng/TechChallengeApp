#!/bin/bash
sudo systemctl enable amazon-ssm-agent
sudo systemctl start amazon-ssm-agent
mkdir /app
cd /app
curl -Lo techchallenge.zip  https://github.com/servian/TechChallengeApp/releases/download/${app_version}/TechChallengeApp_${app_version}_linux64.zip
unzip techchallenge.zip

cat > dist/conf.toml << CONFIG
"DbUser" = "${db_username}"
"DbPassword" = "${db_password}"
"DbName" = "${db_name}"
"DbPort" = "${db_port}"
"DbHost" = "${db_host}"
"ListenHost" = "${listen_host}"
"ListenPort" = "${listen_port}"
CONFIG

cat > /etc/systemd/system/techchallenge.service << SERVICE
[Unit]
Description=TechChallengeApp

[Service]
WorkingDirectory=/app/dist
ExecStart=/app/dist/TechChallengeApp serve
Restart=always

[Install]
WantedBy=multi-user.target
SERVICE

systemctl daemon-reload
systemctl start techchallenge
