# Zabbix Monitoring Systemd
Zabbix template for Systemd.

The only difference with the official template is:
- Use of Active Agent
- Discovery every 6h instead of 30min
- deploy.sh to setup proper permission for **Zabbix Agent 2**
- Macro `{$SYSTEMD.NAME.SERVICE.NOT_MATCHES} = rsync.service`
- Added item and trigger for result of `systemctl is-system-running`

Works for Zabbix 6.0 Active Agent 2

## Deploy Commands

Everything is executed by only a few basic deploy scripts. 

```bash
cd /usr/local/src
git clone https://github.com/Futur-Tech/futur-tech-zabbix-systemd.git
cd futur-tech-zabbix-systemd

./deploy.sh 
# Main deploy script

./deploy-update.sh -b main
# This script will automatically pull the latest version of the branch ("main" in the example) and relaunch itself if a new version is found. Then it will run deploy.sh. Also note that any additional arguments given to this script will be passed to the deploy.sh script.
```

Finally import the template YAML in Zabbix Server and attach it to your host.
