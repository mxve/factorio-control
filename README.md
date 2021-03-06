# factorio-docker-control
## A simple script to control, update & backup [factorio-docker](https://github.com/factoriotools/factorio-docker)

Make sure settings at the top of [`factorio.sh`](factorio.sh) are correct
```
# /--------------------------------------------------------------------------------------------------\ #
#	Settings                                Use "factorio.sh update stable/latest" to apply changes

	factorioPath="/opt/factorio"		# factorio server path (Default: /opt/factorio)
	factorioBackupPath="/root/backups"	# directory to store backups in (Default: /root/backups/)
	factorioPort=34197			# factorio port (Default: 34197)
	factorioRconPort=27015			# factorio rcon port (Default: 27015), set to 0 to disable
	factorioDockerName="factorio"		# docker container & backup file name (Default: factorio)
	factorioBackupMaxAge=2			# max. age of backups in days (Default: 3)

# \--------------------------------------------------------------------------------------------------/ #
```

```
Usage:
  factorio.sh [args]
                ->help
                ->start
                ->stop
                ->restart
                ->logs
                ->backup
                ->update [args]
                        ->stable
                        ->latest

Ex. ./factorio.sh update stable
```
