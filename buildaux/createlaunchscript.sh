#!/bin/bash
SCRIPTPATH="/usr/local/bin/runminecraft.sh"

# write out script to start minecraft.
tee ${SCRIPTPATH} << 'EOF'
#!/bin/bash
cd /minecraft/data
echo "eula=true" > eula.txt
echo java "-Xms${XMS}" "-Xmx${XMX}" -jar "/minecraft/minecraft_server.jar" nogui
java "-Xms${XMS}" "-Xmx${XMX}" -jar "/minecraft/minecraft_server.jar" nogui
EOF

chmod a+rx ${SCRIPTPATH}
