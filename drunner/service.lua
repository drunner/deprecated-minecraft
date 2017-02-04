-- drunner service configuration for helloworld

function drunner_setup()
-- addconfig(NAME, DESCRIPTION, DEFAULT VALUE, TYPE, REQUIRED, USERSETTABLE)
   addconfig("PORT","The port to run minecraft on.","25565","port",true,true)
   addconfig("XMS","Initial memory allocation","1G","string",true,true)
   addconfig("XMX","Maximum memory allocation","2G","string",true,true)

   addconfig("RUNNING","Is the service running","false","bool",true,false)

-- addvolume(NAME, [BACKUP], [EXTERNAL])
   addvolume("drunner-${SERVICENAME}-minecraftdata")

-- addcontainer(NAME)
end


-- everything past here are functions that can be run from the commandline,
-- e.g. helloworld run
containername = "drunner-${SERVICENAME}-minecraft"

function start()
   print(dsub("Launching minecraft with ${XMS} memory (${XMX} max)"))

   dconfig_set("RUNNING","true")

   if (drunning(containername)) then
      print("Minecraft is already running.")
   else
      result=drun("docker", "run", "-d",
      "-p", "${PORT}:25565",
      "-p", "${PORT}:25565/udp",
      "-v", "drunner-${SERVICENAME}-minecraftdata:/minecraft/data",
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
  dconfig_set("RUNNING","false")
  dstop(containername)
end

function obliterate_start()
   stop()
end

function uninstall_start()
   stop()
end

function update_start()
   dstop(containername)
end

function update_end()
   if (dconfig_get("RUNNING")=="true") then
      start()
   end
end

function backup_start()
   drun("docker","pause",containername)
end

function backup_end()
   drun("docker","unpause",containername)
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
