# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit java-utils-2

MY_P="apache-${P/-client/}"

DESCRIPTION="Apache HttpComponents Core"
HOMEPAGE="http://ws.apache.org/xmlrpc/client.html"
SRC_URI="mirror://apache/ws/xmlrpc/binaries/${MY_P/-bin/}-bin.tar.gz"

LICENSE="Apache-2.0"
SLOT="4"
KEYWORDS="~amd64"
IUSE="doc"

RDEPEND=">=virtual/jre-1.5
	dev-java/commons-logging
	dev-java/ws-commons-util"

S="${WORKDIR}/${MY_P/-bin/}"

src_install() {
	java-pkg_register-dependency commons-logging,ws-commons-util
	java-pkg_newjar "lib/xmlrpc-server-${PV}.jar" xmlrpc-server.jar
	java-pkg_newjar "lib/xmlrpc-client-${PV}.jar" xmlrpc-client.jar
	java-pkg_newjar "lib/xmlrpc-common-${PV}.jar" xmlrpc-common.jar
	use doc && java-pkg_dojavadoc docs
}
