# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit java-utils-2

DESCRIPTION="a network application framework for high performance and high scalability network applications"
HOMEPAGE="http://mina.apache.org/"
SRC_URI="mirror://apache/mina/mina/${PV}/dist/${P/-bin/}-bin.tar.gz"

LICENSE="Apache-2.0"
SLOT="4"
KEYWORDS="~amd64"
IUSE="doc"

RDEPEND=">=virtual/jre-1.5
	dev-java/slf4j-api"

S="${WORKDIR}/${P/-bin/}"

src_install() {
	java-pkg_register-dependency slf4j-api
	java-pkg_newjar "dist/mina-core-${PV}.jar" mina-core.jar
	use doc && java-pkg_dojavadoc docs
}
