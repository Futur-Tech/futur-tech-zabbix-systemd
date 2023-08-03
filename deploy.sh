#!/usr/bin/env bash

source "$(dirname "$0")/ft-util/ft_util_inc_var"

# Checking which Zabbix Agent is detected
if $(which zabbix_agent2 >/dev/null); then
    echo "systemctl restart zabbix-agent*" | at now + 1 min &>/dev/null ## restart zabbix agent with a delay
    $S_LOG -s $? -d "$S_NAME" "Scheduling Zabbix Agent 2 Restart"
elif $(which zabbix_agentd >/dev/null); then
    $S_LOG -s err -d $S_NAME "This template is only for Zabbix Agent 2"
    exit 1
else
    $S_LOG -s crit -d $S_NAME "Zabbix is not installed"
    exit 1
fi

$S_LOG -d "$S_NAME" "End $S_NAME"

exit
