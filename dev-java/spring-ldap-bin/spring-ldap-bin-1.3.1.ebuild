# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit java-utils-2

MY_PV="${PV}.RELEASE"
MY_PN="${PN/-bin/}"
MY_P="${MY_PN}-${MY_PV}"

DESCRIPTION="Spring Framework"
HOMEPAGE="http://www.springsource.org"
SRC_URI="http://s3.amazonaws.com/dist.springframework.org/release/LDAP/${MY_P}-minimal.zip"

LICENSE="Apache-2.0"
SLOT="4"
KEYWORDS="~amd64"
IUSE=""

RDEPEND=">=virtual/jre-1.5"

S="${WORKDIR}/${MY_P}"

src_install() {
	for f in dist/modules/*.jar; do
		java-pkg_newjar "$f" "$(basename "$f" | sed "s/-${MY_PV}//")"
	done
}
