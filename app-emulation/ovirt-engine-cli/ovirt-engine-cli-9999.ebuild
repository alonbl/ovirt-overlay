# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1
inherit git-2

DESCRIPTION="Command line interface for the oVirt engine"
HOMEPAGE="http://www.ovirt.org/wiki/CLI"
EGIT_REPO_URI="git://gerrit.ovirt.org/ovirt-engine-cli.git"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="${PYTHON_DEPS}"
RDEPEND="${DEPEND}
		>=app-emulation/ovirt-engine-sdk-python-9999
		dev-python/kitchen
		dev-python/pexpect
		dev-python/ply"
