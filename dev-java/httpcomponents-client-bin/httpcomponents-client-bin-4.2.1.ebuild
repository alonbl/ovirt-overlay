# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit java-utils-2

DESCRIPTION="Apache HttpComponents Core"
HOMEPAGE="http://hc.apache.org/index.html"
SRC_URI="http://www.eng.lsu.edu/mirrors/apache/httpcomponents/httpclient/binary/${P/-bin/}-bin.tar.gz"

LICENSE="Apache-2.0"
SLOT="4"
KEYWORDS="~amd64"
IUSE="doc"

RDEPEND=">=virtual/jre-1.5"

S="${WORKDIR}/${P/-bin/}"

src_install() {
	java-pkg_newjar "lib/httpclient-${PV}.jar" httpclient.jar
	java-pkg_newjar "lib/httpclient-cache-${PV}.jar" httpclient-cache.jar
	java-pkg_newjar "lib/httpcore-${PV}.jar" httpcore.jar
	java-pkg_newjar "lib/httpmime-${PV}.jar" httpmime.jar
	use doc && java-pkg_dojavadoc javadoc
}
