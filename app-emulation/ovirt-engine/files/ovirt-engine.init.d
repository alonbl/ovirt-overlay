#!/sbin/runscript
# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

command="/usr/bin/engine-service"
command_args="--pidfile ${OVIRT_ENGINE_PIDFILE} --quiet --foreground start"
command_background="yes"
start_stop_daemon_args="--user ovirt:ovirt"
pidfile="/var/run/ovirt-engine.pid"

depend() {
	use logger
	need net
}

