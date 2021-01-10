#!/bin/bash

# /--------------------------------------------------------------------------------------------------\ #
#	Settings                                Use "factorio.sh update stable/latest" to apply changes

	factorioPath="/opt/factorio"		# factorio server path (Default: /opt/factorio)
	factorioBackupPath="/root/backups"	# directory to store backups in (Default: /root/backups/)
	factorioPort=34197			# factorio port (Default: 34197)
	factorioRconPort=27015			# factorio rcon port (Default: 27015), set to 0 to disable
	factorioDockerName="factorio"		# docker container & backup file name (Default: factorio)
	factorioBackupMaxAge=2			# max. age of backups in days (Default: 3)

# \--------------------------------------------------------------------------------------------------/ #



# Build docker arguments for fUpdate

factorioDockerArgs="-d -e PORT=${factorioPort} 
					-p ${factorioPort}:34197/udp "

# Check wether rcon should be exposed
if [[ "$factorioRconPort" -gt 0 ]]; then
	factorioDockerArgs="${factorioDockerArgs} 
						-p ${factorioRconPort}:27015/tcp "
fi

factorioDockerArgs="${factorioDockerArgs} 
					-v ${factorioPath}:/factorio 
					--name ${factorioDockerName} 
					--restart=always 
					factoriotools/factorio" # tag will be set by fUpdate


# Define functions

fHelp()
{
	echo "Usage:"
	echo "  $0 [args]"
	echo "		->help"
	echo "		->start"
	echo "		->stop"
	echo "		->restart"
	echo "		->logs"
	echo "		->backup"
	echo "		->update [args]"
	echo "			 ->stable"
	echo "			 ->latest"
	echo ""
	echo "Ex. $0 update stable"
}

fBackup()
{
	vDate=$(date +%d-%m-%Y_%H-%M-%S)
	vFilename=${factorioDockerName}_${vDate}
	
	echo "Creating backup ${factorioBackupPath}/${vFilename}.tar.gz"
	cd ${factorioPath}
	tar cf ${vFilename}.tar *
	gzip ${vFilename}.tar
	mv ${vFilename}.tar.gz ${factorioBackupPath}/
	
	echo "Deleting backups older than ${factorioBackupMaxAge} days"
	find ${factorioBackupPath}/ -mtime +${factorioBackupMaxAge} -exec rm {} \;
}

# fUpdate [stable/testing]
fUpdate()
{
	# Check wether correct tag was supplied, if not exit with return code 1
	if [[ "$1" != "stable" ]]; then
		if  [[ "$1" != "latest" ]]; then
			fHelp
			return 1
		fi
	fi
	
	fBackup
	
	echo "Stopping ${factorioDockerName}"
	docker stop ${factorioDockerName}
	echo "Deleting ${factorioDockerName}"
	docker rm ${factorioDockerName}
	echo "Pulling factoriotools/factorio:${1}"
	docker pull factoriotools/factorio:$1
	echo "Starting ${factorioDockerName}"
	docker run ${factorioDockerArgs}:$1
	echo "${factorioDockerName}:"
	echo "	Port: 			${factorioPort}"
	echo "	Rcon port: 		${factorioRconPort}"
	echo "	Path: 			${factorioPath}"
	echo "	Backup path: 		${factorioBackupPath}"
	echo "	Backup max age: 	${factorioBackupMaxAge} days"
}

case ${1} in
	"")
		fHelp
	;;
	help)
		fHelp
	;;
	start)
		docker start ${factorioDockerName}
	;;
	stop)
		docker stop ${factorioDockerName}
	;;
	logs)
		docker logs ${factorioDockerName} --follow
	;;
	restart)
		docker stop ${factorioDockerName}
		docker start ${factorioDockerName}
	;;
	update)
		fUpdate $2
	;;
	backup)
		fBackup
	;;
esac
