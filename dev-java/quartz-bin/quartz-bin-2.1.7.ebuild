# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit java-utils-2

MY_PN="${PN/-bin}"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Enterprise Job Scheduler"
HOMEPAGE="http://quartz-scheduler.org/"
SRC_URI="http://d2zwv9pap9ylyd.cloudfront.net/${MY_P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="4"
KEYWORDS="~amd64"
IUSE="doc"

RDEPEND=">=virtual/jre-1.5
	dev-java/slf4j-api
	dev-java/log4j
	dev-java/c3p0"

S="${WORKDIR}/${MY_P}"

src_install() {
	java-pkg_register-dependency slf4j-api,log4j,c3p0
	java-pkg_newjar ${MY_P}.jar ${MY_PN}.jar
	use doc && java-pkg_dojavadoc docs
}
