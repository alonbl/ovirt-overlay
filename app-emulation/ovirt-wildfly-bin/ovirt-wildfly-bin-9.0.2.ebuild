# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit versionator

MY_PN="${PN/ovirt-/}"
MY_PN="${MY_PN/-bin/}"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="oVirt JBoss"
HOMEPAGE="http://www.wildfly.org"
SRC_URI="http://download.jboss.org/wildfly/${PV}.Final/${MY_P}.Final.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND=">=virtual/jre-1.7"

S="${WORKDIR}/${MY_P}.Final"

#pkg_setup() {
#	enewgroup jboss
#	enewuser jboss -1 "" "" jboss
#}

src_install() {
	local INTO="/usr/share/ovirt/${MY_PN}"
	local PREFIX="/ovirt"
	insinto "${INTO}"
	doins -r .
	for d in standalone docs; do
		rm -fr "${ED}${INTO}/${d}"
	done
	dodoc -r docs/*
	#insopts -o jboss -g jboss
	#diropts -o jboss -g jboss
	dodir "/var/lib/ovirt/${MY_PN}"
	insinto "/var/lib${PREFIX}/${MY_PN}"
	doins -r standalone
	dosym "/var/lib${PREFIX}/${MY_PN}" "${INTO}/standalone"

	find "${ED}" -name '*.so' -exec rm {} \;
}
