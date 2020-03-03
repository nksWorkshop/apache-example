# Welcome to TEC2020 - Build your own DAST

## Join our RIOT chat for sharing commands, passwords etc.

open [https://riot.im/app/#/room/#tec2020:matrix.org](https://riot.im/app/#/room/#tec2020:matrix.org)

## Launch your gitpod instance

open [https://gitpod.io/#https://github.com/nksWorkshop/apache-example](https://gitpod.io/#https://github.com/nksWorkshop/apache-example)

## Terminal Commands to try
* `apachectl start` - start Apache Web Server (it's started automatically on workspace launch)
* `apachectl stop` - stop Apache Web Server
* `gp open /var/log/apache2/access.log` - Open Apache access.log in Gitpod editor
* `gp open /var/log/apache2/error.log` - Open Apache error.log in Gitpod editor
* `multitail /var/log/apache2/access.log -I /var/log/apache2/error.log` - View and follow logs in Terminal

## Hackazon Code

You can find the code in ```/workspace/apache-example/hackazon```


```bash run_scanner.sh --payload ../scans/scanrule_zap1.json --auth "pepe:Y2RhNmQ2NWQzMThlMGU5ZGRiMDUyOGRm" --backend http://swissrelsio.best:8080
```
