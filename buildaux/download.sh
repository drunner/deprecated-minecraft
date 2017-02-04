#!/bin/bash
# read in VERSION variable.
source /buildaux/version.sh

# download minecraft server jar
mkdir /minecraft
cd /minecraft
wget -q "https://s3.amazonaws.com/Minecraft.Download/versions/${VERSION}/minecraft_server.${VERSION}.jar"
mv "minecraft_server.${VERSION}.jar" "minecraft_server.jar"
chown -R druser:drgroup /minecraft
#chmod a+r /minecraft/*
