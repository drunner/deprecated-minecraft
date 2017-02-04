-- drunner service configuration for helloworld

addenv("PORT","25565","The port to run minecraft on.")
addenv("XMS","1G","Initial memory allocation","1G")
addenv("XMX","2G","Maximum memory allocation","2G")

datavol = "drunner-${SERVICENAME}-minecraftdata"
containername = "drunner-${SERVICENAME}-minecraft"

function start()
   print(dsub("Launching minecraft with ${XMS} memory (${XMX} max)"))

   if (drunning(containername)) then
      print("Minecraft is already running.")
   else
      result=docker("run", "-d",
      "-p", "${PORT}:25565",
      "-p", "${PORT}:25565/udp",
      "-v", datavol .. ":/minecraft/data",
      "-e", "XMS",
      "-e", "XMX",
      "--restart=always",
      "--name", containername,
      "${IMAGENAME}",
      "/usr/local/bin/runminecraft.sh")

      if result~=0 then
        print("Failed to start minecraft.")
      end
   end
end

function stop()
  dockerstop(containername)
end

function obliterate()
   stop()
end

function uninstall()
   stop()
end

function update()
   stop()
-- hmmm
   dockerpull("drunner/minecraft")
   start()
end

function backup()
   docker("pause",containername)
   dockerbackup(datavol)
   docker("unpause",containername)
end

function info()
   if (drunning(containername)) then
      print(dsub("Minecraft is running on port ${PORT}."))
   else
      print("Minecraft is not currently running.")
   end
end

function enter()
   print("Run:")
   print(dsub("docker exec -ti "..containername.." /bin/bash"))
end


function help()
   return [[
   NAME
      ${SERVICENAME} - Runs minecraft

   SYNOPSIS
      ${SERVICENAME} help             - This help
      ${SERVICENAME} configure [PORT] - Show configuration, or set PORT
      ${SERVICENAME} start            - Make it go!
      ${SERVICENAME} stop             - Stop it

   DESCRIPTION
      Built from ${IMAGENAME}.
   ]]
end
