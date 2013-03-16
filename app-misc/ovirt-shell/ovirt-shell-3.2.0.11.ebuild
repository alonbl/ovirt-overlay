# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

PYTHON_COMPAT=( python{2_5,2_6,2_7} )
inherit distutils-r1

DESCRIPTION="A command-line interface to oVirt Virtualization"
HOMEPAGE="http://www.ovirt.org/wiki/CLI"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=dev-python/ovirt-engine-sdk-3.2.0.10[${PYTHON_USEDEP}]
	>=dev-python/pexpect-u-2.3
	>=dev-python/ply-3.3
	>=dev-python/kitchen-1[${PYTHON_USEDEP}]"

src_prepare() {
	sed -i 's/-SNAPSHOT//' "${S}/setup.py"
}
