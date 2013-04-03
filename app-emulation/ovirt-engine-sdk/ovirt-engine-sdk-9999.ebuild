# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
PYTHON_DEPEND="2:2.6"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.*"

inherit distutils eutils git-2

DESCRIPTION="A SDK interface to oVirt Virtualization"
HOMEPAGE="http://www.ovirt.org/SDK"
EGIT_REPO_URI="git://gerrit.ovirt.org/ovirt-engine-sdk.git"
EGIT_BRANCH="master"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"
