# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/python-lzo/python-lzo-1.08.ebuild,v 1.3 2011/02/26 23:24:28 arfrever Exp $

EAPI="4"
PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.*"

inherit distutils eutils

DESCRIPTION="Python bindings for the ethtool kernel interface"
HOMEPAGE="http://dsommers.fedorapeople.org/python-ethtool/"
SRC_URI="http://dsommers.fedorapeople.org/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"
