# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit java-utils-2

DESCRIPTION="JSR 303 - Bean Validation"
HOMEPAGE="http://www.hibernate.org/subprojects/validator.html"
SRC_URI="https://repository.jboss.org/nexus/content/groups/public-jboss/org/hibernate/${PN/-bin/}/${PV}.Final/${P/-bin/}.Final.jar"

LICENSE="Apache-2.0"
SLOT="4"
KEYWORDS="~amd64"
IUSE=""

RDEPEND=">=virtual/jre-1.5"

S="${WORKDIR}"

src_unpack() {
	:
}

src_install() {
	java-pkg_newjar "${DISTDIR}/${P/-bin/}.Final.jar" ${PN}.jar
}
