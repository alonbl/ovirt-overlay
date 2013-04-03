# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
PYTHON_DEPEND="2:2.6"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.*"

inherit eutils

DESCRIPTION="Upload isos to Open Virtualization Manager"
HOMEPAGE="http://gerrit.ovirt.org"
SRC_URI=""

case ${PV} in
9999)
	inherit autotools git-2
	EGIT_REPO_URI="git://gerrit.ovirt.org/ovirt-iso-uploader"
	EGIT_BRANCH="master"
	;;
*)
	SRC_URI=""
	;;
esac

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="sys-devel/gettext"
RDEPEND="${DEPEND}
		app-emulation/ovirt-engine-sdk"

pkg_setup() {
	enewgroup kvm 36
	enewuser vdsm 36 -1 -1 kvm
}

src_unpack() {
	[[ ${PV} == "9999" ]] && git-2_src_unpack || default
}

src_prepare() {
	[[ ${PV} == "9999" ]] && eautoreconf
}

src_compile() {
	emake all || eerror "Failed"
}
