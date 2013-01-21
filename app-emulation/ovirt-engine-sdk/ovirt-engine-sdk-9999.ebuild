# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
PYTHON_DEPEND="2:2.6"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.*"

inherit distutils eutils

DESCRIPTION="A SDK interface to oVirt Virtualization"
HOMEPAGE="http://www.ovirt.org/SDK"

case ${PV} in
9999)
	inherit autotools git-2
	EGIT_REPO_URI="git://gerrit.ovirt.org/ovirt-engine-sdk.git"
	EGIT_BRANCH="master"
	;;
*)
	SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
	;;
esac

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

src_unpack() {
	[[ ${PV} == "9999" ]] && git-2_src_unpack || default
}

src_compile() {
	distutils_src_compile
}

src_install() {
	distutils_src_install
}
