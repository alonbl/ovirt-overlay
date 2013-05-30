# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

DESCRIPTION="VNC client using HTML5 (WebSockets, Canvas) with encryption (wss://) support"
HOMEPAGE="http://kanaka.github.io/noVNC/"
SRC_URI="https://github.com/kanaka/noVNC/archive/v0.4.tar.gz -> ${P}.tar.gz"

LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

src_install() {
	dodir /usr/share/novnc
	insinto /usr/share/novnc
	doins -r *.html images include
	dodoc README.md
}
