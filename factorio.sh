#!/bin/bash

factorioPath="/opt/factorio"
factorioBackupPath="/root/backups"
factorioUDP=34197
factorioTCP=27015
factorioDockerName="factorio"
factorioBackupMaxAge=3


fHelp()
{
		echo "Usage:"
		echo "  $0 [args]"
		echo "		->help"
		echo "		->start"
		echo "		->stop"
		echo "		->restart"
		echo "		->logs"
		echo "		->update [args]"
		echo "			 ->stable"
		echo "			 ->latest"
		echo "		->backup"
		echo ""
		echo "Ex. $0 update stable"
}

fUpdate()
{
		fBackup
		docker stop $factorioDockerName
		docker rm $factorioDockerName
		docker pull factoriotools/factorio:$1
		docker run -d -p $factorioUDP:$factorioUDP/udp -p $factorioTCP:$factorioTCP/tcp -v $factorioPath:/factorio --name $factorioDockerName --restart=always factoriotools/factorio:$1
}

fBackup()
{
		_DATE=$(date +%d-%m-%Y_%H-%M-%S)
		cd $factorioPath
		tar cf factorio_$_DATE.tar *
		gzip factorio_$_DATE.tar
		mv factorio_$_DATE.tar.gz $factorioBackupPath/
		find $factorioBackupPath/ -mtime +$factorioBackupMaxAge -exec rm {} \;
}

case $1 in
		"")
				fHelp
		;;
		help)
				fHelp
		;;
		start)
				docker start $factorioDockerName
		;;
		stop)
				docker stop $factorioDockerName
		;;
		logs)
				docker logs $factorioDockerName
		;;
		restart)
				docker stop $factorioDockerName
				docker start $factorioDockerName
		;;
		update)
				case $2 in
						"")
								fHelp
						;;
						stable)
								fUpdate stable
						;;
						latest)
								fUpdate latest
						;;
				esac
		;;
		backup)
				fBackup
		;;
esac