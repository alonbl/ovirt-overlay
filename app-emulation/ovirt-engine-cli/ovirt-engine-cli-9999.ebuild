# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
PYTHON_DEPEND="2:2.6"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.*"

inherit distutils eutils

DESCRIPTION="command line interface for the oVirt engine"
HOMEPAGE="http://www.ovirt.org/wiki/CLI"
SRC_URI=""

case ${PV} in
9999)
	inherit autotools git-2
	EGIT_REPO_URI="git://gerrit.ovirt.org/ovirt-engine-cli.git"
	EGIT_BRANCH="master"
	;;
*)
	SRC_URI="http://resources.ovirt.org/releases/${PV:0:3}/src/${P}.tar.gz"
	;;
esac

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
		>=app-emulation/ovirt-engine-sdk-9999
		dev-python/kitchen
		dev-python/pexpect
		dev-python/ply"

S="${WORKDIR}/${PN}"

src_unpack() {
	[[ ${PV} == "9999" ]] && git-2_src_unpack || default
}

src_compile() {
	distutils_src_compile
}

src_install() {
	distutils_src_install
}
