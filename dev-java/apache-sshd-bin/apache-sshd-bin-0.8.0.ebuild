# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit java-utils-2

DESCRIPTION="Pure java library to support the SSH protocols on both the client and server side"
HOMEPAGE="http://mina.apache.org/sshd-project/"
SRC_URI="mirror://apache/mina/sshd/${PV}/dist/${P/-bin/}.tar.gz"

LICENSE="Apache-2.0"
SLOT="4"
KEYWORDS="~amd64"
IUSE=""

RDEPEND=">=virtual/jre-1.5
	dev-java/apache-mina-bin"

S="${WORKDIR}/${P/-bin/}"

src_install() {
	java-pkg_register-dependency apache-mina-bin-4
	java-pkg_newjar "lib/sshd-core-${PV}.jar" sshd-core.jar
}
