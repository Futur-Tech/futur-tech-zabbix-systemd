#!/usr/bin/env bash

source "$(dirname "$0")/ft-util/ft_util_inc_var"

app_name="futur-tech-zabbix-systemd"
required_pkg_arr=( "at" )

sudoers_etc="/etc/sudoers.d/${app_name}"

# Checking which Zabbix Agent is detected and adjust include directory
$(which zabbix_agent2 >/dev/null) && zbx_conf_agent_d="/etc/zabbix/zabbix_agent2.d"
# $(which zabbix_agentd >/dev/null) && zbx_conf_agent_d="/etc/zabbix/zabbix_agentd.conf.d" This template is only for Zabbix Agent 2
if [ ! -d "${zbx_conf_agent_d}" ] ; then $S_LOG -s crit -d $S_NAME "${zbx_conf_agent_d} Zabbix Include directory not found" ; exit 10 ; fi

$S_LOG -d $S_NAME "Start $S_DIR_NAME/$S_NAME $*"

echo "
  INSTALL NEEDED PACKAGES
------------------------------------------"

$S_DIR_PATH/ft-util/ft_util_pkg -u -i ${required_pkg_arr[@]} || exit 1

echo "
  SETUP SUDOER FILES
------------------------------------------"

$S_LOG -d $S_NAME -d "$sudoers_etc" "==============================="

echo 'Defaults:zabbix !requiretty' | sudo EDITOR='tee' visudo --file=$sudoers_etc &>/dev/null
echo 'zabbix ALL=(ALL) NOPASSWD:/usr/bin/rdiff-backup --server --restrict-read-only /' | sudo EDITOR='tee -a' visudo --file=$sudoers_etc &>/dev/null

cat $sudoers_etc | $S_LOG -d "$S_NAME" -d "$sudoers_etc" -i 

$S_LOG -d $S_NAME -d "$sudoers_etc" "==============================="

echo "
  RESTART ZABBIX LATER
------------------------------------------"

echo "systemctl restart zabbix-agent*" | at now + 1 min &>/dev/null ## restart zabbix agent with a delay
$S_LOG -s $? -d "$S_NAME" "Scheduling Zabbix Agent Restart"

$S_LOG -d "$S_NAME" "End $S_NAME"

exit