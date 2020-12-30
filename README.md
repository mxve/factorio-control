# factorio-control
## A simple script to control, update & backup [factorio-docker](https://github.com/factoriotools/factorio-docker)

Make sure settings at the top of [`factorio.sh`](factorio.sh) are correct
```
factorioPath="/opt/factorio"		# factorio server path (Default: /opt/factorio)
factorioBackupPath="/root/backups"	# directory to store backups in (Default: /root/backups/)
factorioUDP=34197			# factorio UDP port (Default: 34197)
factorioTCP=27015			# factorio TCP port (Default: 27015)
factorioDockerName="factorio"		# docker container name (Default: factorio)
factorioBackupMaxAge=3			# max. age of backups in days (Default: 3)
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
