# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit versionator

MY_PN="${PN/ovirt-/}"
MY_PN="${MY_PN/-bin/}"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="oVirt JBoss"
HOMEPAGE="http://www.jboss.org/jbossas"
SRC_URI="http://download.jboss.org/${MY_PN//-/}/$(get_version_component_range 1-2)/${MY_P}.Final/${MY_P}.Final.tar.gz"

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

src_prepare() {
	for d in \
			modules/org/jboss/as/web/main/lib \
			modules/org/hornetq/main/lib; do
		find "${d}" -type f -exec rm "{}" \;
	done
}

src_install() {
	local INTO="/usr/share/ovirt/jboss-as"
	local PREFIX="/ovirt"
	insinto "${INTO}"
	doins -r .
	for d in standalone docs; do
		rm -fr "${ED}${INTO}/${d}"
	done
	dodoc -r docs/*
	#insopts -o jboss -g jboss
	#diropts -o jboss -g jboss
	dodir /var/lib/ovirt/jboss-as
	insinto /var/lib${PREFIX}/jboss-as
	doins -r standalone
	dosym /var/lib${PREFIX}/jboss-as "${INTO}/standalone"
	chmod +x "${ED}${INTO}/bin"/*.sh
}
