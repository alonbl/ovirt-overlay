# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

DESCRIPTION="Spice HTML5"
HOMEPAGE="http://spice-space.org"
SRC_URI="http://www.spice-space.org/download/${PN}/${P}.tar.gz"

LICENSE="LGPL-3+"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

src_compile() {
	:
}

src_install() {
	find . \( -iname '*.html' -or -iname '*.js' -or -iname '*.css' \) -exec install --mode=644 -D {} "${ED}/usr/share/spice-html5/{}" \;
}
