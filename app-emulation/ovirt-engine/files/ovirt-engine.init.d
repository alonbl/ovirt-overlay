#!/sbin/runscript
# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

pidfile="/var/run/ovirt-engine.pid"
command="/usr/bin/engine-service"
command_args="--pidfile=${pidfile} start"
command_background="yes"
start_stop_daemon_args="--user ovirt:ovirt"

depend() {
	use logger
	need net
}

start_pre() {
	ulimit -n ${NOFILE:-65535}
}
