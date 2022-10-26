#!/bin/bash

#--------------------------------------------
# V2Ray Helper
# author：Prk
# site：https://imprk.me/
# slogan：Install V2Ray
#--------------------------------------------

# Tips
echo -e "==========";
echo -e " V2Ray Helper [Version: 1.0]";
echo -e " author: Prk (https://imprk.me/)";
echo -e "";
echo -e " Welcome!";
echo -e "==========";
echo -e "";

# Var
v2ray_version="5.1.0";
uuid="";
port="";

# Input
read -p "V2Ray Port (Default: 10086): " port
read -p "V2Ray UUID (Default: 23ad6b10-8d1a-40f7-8ad0-e3e35cd38297): " uuid
if [ "$port" = "" ]; then
    port="10086";
fi
if [ "$uuid" = "" ]; then
    uuid="23ad6b10-8d1a-40f7-8ad0-e3e35cd38297";
fi

# Create Dir
mkdir /usr/bin/v2ray;
mkdir /etc/v2ray;
mkdir /var/log/v2ray;
touch /etc/v2ray/config.json;
touch /etc/systemd/system/v2ray.service;

# Install Package
yum update;
yum install curl -y;
yum install vim -y;
yum install wget -y;
yum install unzip -y;

# Download and Unzip V2Ray Package
cd /usr/bin/v2ray;
wget https://github.com/v2fly/v2ray-core/releases/download/v5.1.0/v2ray-linux-64.zip;
unzip v2ray-linux-64.zip;

# Delete Files
cd /usr/bin/v2ray;
rm -rf v2ray-linux-64.zip;
rm -rf config.json;
rm -rf vpoint_socks_vmess.json;
rm -rf vpoint_vmess_freedom.json;
rm -rf systemd;
chmod 777 v2ray;

# Change Config File
# cd /etc/v2ray;
echo "{\"inbounds\":[{\"port\":"$port",\"protocol\":\"vmess\",\"settings\":{\"clients\":[{\"id\":\""$uuid"\"}]}}],\"outbounds\":[{\"protocol\":\"freedom\",\"settings\":{}}]}" > /etc/v2ray/config.json;

# Set Systemctl
# cd /etc/systemd/system/;
echo -e "[Unit]\nDescription=V2Ray Service\nDocumentation=https://www.v2fly.org/\nAfter=network.target nss-lookup.target\n\n[Service]\nUser=nobody\nCapabilityBoundingSet=CAP_NET_ADMIN CAP_NET_BIND_SERVICE\nAmbientCapabilities=CAP_NET_ADMIN CAP_NET_BIND_SERVICE\nNoNewPrivileges=true\nExecStart=/usr/bin/v2ray/v2ray run -config /etc/v2ray/config.json\nRestart=on-failure\nRestartPreventExitStatus=23\n\n[Install]\nWantedBy=multi-user.target" > /etc/systemd/system/v2ray.service;
systemctl enable v2ray;
systemctl reload v2ray;
systemctl status v2ray;

echo -e "[V2Ray Helper] SUCCESS!";
