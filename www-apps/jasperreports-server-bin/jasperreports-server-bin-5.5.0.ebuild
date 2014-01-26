# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils

MY_PN="${PN/-bin}-cp"

DESCRIPTION="JasperReports Server"
HOMEPAGE="http://community.jaspersoft.com"
SRC_URI="mirror://sourceforge/jasperserver/JasperServer/JasperReports%20Server%20Community%20Edition%20${PV}/${MY_PN}-${PV}-bin.zip"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_PN}-${PV}-bin"

src_prepare() {
	epatch "${FILESDIR}/${P}-additional-config.patch"
	epatch "${FILESDIR}/${P}-install_resources.patch"
	find "${S}" -name '*.exe' -exec rm -f "{}" \;
}

src_compile() {
	:
}

src_install() {
	insinto "/usr/share/${PN}"
	doins -r *
}
