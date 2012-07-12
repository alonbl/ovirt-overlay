# Copyright 1999-2012 Gentoo Foundation
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


pkg_setup() {
	enewgroup ovirt
	enewuser ovirt -1 "" "" ovirt,postgres
}

src_prepare() {
	# remove native binaries
	rm -fr \
		modules/org/jboss/as/web/main/lib/ \
		modules/org/hornetq/main/lib
}

src_install() {
	insinto /usr/share/ovirt/jboss-as
	doins -r .
	for d in standalone docs; do
		rm -fr "${ED}/usr/share/ovirt/jboss-as/${d}"
	done
	dodoc -r docs/*
	insopts -o ovirt -g ovirt
	diropts -o ovirt -g ovirt
	dodir /var/lib/ovirt-engine/jboss-as
	insinto /var/lib/ovirt-engine/jboss-as
	doins -r standalone
	dosym /var/lib/ovirt-engine/jboss-as /usr/share/ovirt/jboss-as/standalone
	chmod +x "${ED}/usr/share/ovirt/jboss-as/bin"/*.sh
}
