# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"
PYTHON_DEPEND="2:2.7"

inherit python git-2 autotools

DESCRIPTION="Virtual desktop server manager"
HOMEPAGE="http://www.ovirt.org"
EGIT_REPO_URI="git://gerrit.ovirt.org/vdsm"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="
	app-admin/sanlock[python]
	app-admin/sudo
	app-arch/tar
	>=app-emulation/libvirt-0.10.2[python]
	app-emulation/qemu
	dev-libs/openssl
	dev-python/cherrypy
	dev-python/nose
	dev-python/pyflakes
	dev-python/pyparted
	dev-python/python-ethtool
	net-fs/nfs-utils
	net-misc/bridge-utils
	net-misc/rsync
	net-misc/wget
	sys-apps/dmidecode
	sys-apps/util-linux
	sys-block/open-iscsi
	sys-fs/dosfstools
	sys-fs/lvm2
	sys-fs/multipath-tools
	sys-fs/udev
	sys-process/procps
	sys-process/psmisc
	virtual/cdrtools
"
#	/usr/sbin/persist
#	/usr/sbin/unpersist
#	/sbin/vconfig -> should be replaced with iproute
#	/bin/systemctl
#	/sbin/grubby -> obosolete
#	/usr/sbin/fence_ilo
#	yum?
#	rpm?
DEPEND="${RDEPEND}
	dev-python/cheetah
	dev-python/pep8"

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup
}

src_prepare() {
	eautoreconf
}

src_configure() {
	econf PYTHON=$(PYTHON --absolute-path)
}

src_test() {
	# the syntax checking in Gentoo is newer than fedora
	# so we disable it for now
	emake -C tests check
}

src_install() {
	default
	python_convert_shebangs -r 2 "${ED}"
}
