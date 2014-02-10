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
	epatch "${FILESDIR}/${P}-write-own.patch"
	epatch "${FILESDIR}/${P}-ANT_OPTS.patch"
	epatch "${FILESDIR}/${P}-java.io.tmpdir.patch"
	find "${S}" -name '*.exe' -exec rm -f "{}" \;
}

src_compile() {
	:
}

src_install() {
	local dir="/usr/share/${PN//-bin}"
	dodir "${dir}"
	# cannot use doins as timestamp
	# must preserve, these guys alter
	# their environment
	# ant ignore if timestamp is the same
	cp -R * "${ED}${dir}"
	find "${ED}${dir}" -type d -exec chmod 0755 {} +
	find "${ED}${dir}" -type f -exec chmod 0644 {} +
	chmod a+x "${ED}${dir}/apache-ant/bin/ant"
	chmod a+x "${ED}${dir}/buildomatic/js-ant"
	chmod a+x "${ED}${dir}/buildomatic"/*.sh
	chmod a+x "${ED}${dir}/buildomatic/bin"/*.sh
}
