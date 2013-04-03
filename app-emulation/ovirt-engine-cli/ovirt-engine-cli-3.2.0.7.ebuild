# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
PYTHON_DEPEND="2:2.7"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.*"

inherit distutils eutils versionator

DESCRIPTION="command line interface for the oVirt engine"
HOMEPAGE="http://www.ovirt.org/wiki/CLI"
SRC_URI="http://resources.ovirt.org/releases/$(get_version_component_range 1-2)/src/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
		>=app-emulation/ovirt-engine-sdk-3.2.0.3
		dev-python/kitchen
		dev-python/pexpect
		dev-python/ply"

S="${WORKDIR}/${PN}"
