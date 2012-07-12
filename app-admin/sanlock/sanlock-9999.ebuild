# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
PYTHON_DEPEND="python? 2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.*"

inherit git-2 distutils

DESCRIPTION="Shared storage lock manager"
HOMEPAGE="https://fedorahosted.org/sanlock/"
EGIT_REPO_URI="git://git.fedorahosted.org/sanlock.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="python"

RDEPEND="dev-libs/libaio
	sys-apps/util-linux"
DEPEND="${DEPEND}"

src_compile() {
	emake -C wdmd
	emake -C src
	use python && cd python && distutils_src_compile
}

src_install() {
	emake -C wdmd install DESTDIR="${ED}"
	emake -C src install DESTDIR="${ED}"
	use python && cd python && distutils_src_install
}
