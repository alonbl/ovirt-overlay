# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

PYTHON_COMPAT=( python{2_5,2_6,2_7} )
inherit distutils-r1

DESCRIPTION="Kitchen contains a cornucopia of useful code"
HOMEPAGE="http://pypi.python.org/pypi/kitchen"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="${PYTHON_DEPS}"
DEPEND="${RDEPEND}"
