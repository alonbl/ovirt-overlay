# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Command line interface for the oVirt engine"
HOMEPAGE="http://www.ovirt.org/wiki/CLI"
SRC_URI="http://resources.ovirt.org/pub/src/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="${PYTHON_DEPS}"
RDEPEND="${DEPEND}
		>=app-emulation/ovirt-engine-sdk-python-3.4
		dev-python/kitchen
		dev-python/pexpect
		dev-python/ply"

S="${WORKDIR}/${PN}"
