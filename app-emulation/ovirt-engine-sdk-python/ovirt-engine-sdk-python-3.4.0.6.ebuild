# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="A SDK interface to oVirt Virtualization"
HOMEPAGE="http://www.ovirt.org/SDK"
SRC_URI="http://resources.ovirt.org/pub/src/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="${PYTHON_DEPS}"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}"
