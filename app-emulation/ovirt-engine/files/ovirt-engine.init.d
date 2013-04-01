#!/sbin/runscript
# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

command="/usr/bin/engine-service"
command_args="start"
command_background="yes"
start_stop_daemon_args=" \
	--user ovirt:ovirt \
	--stdout=/var/log/ovirt-engine/console.log \
	--stderr=/var/log/ovirt-engine/console.log \
"
pidfile="/var/run/ovirt-engine.pid"

depend() {
	use logger
	need net
}

start_pre() {
	ulimit -n ${NOFILE:-65535}
}
