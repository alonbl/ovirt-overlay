# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit user java-pkg-2 python-r1
inherit git-2

DESCRIPTION="oVirt Engine Data Warehouse"
HOMEPAGE="http://www.ovirt.org"
EGIT_REPO_URI="git://gerrit.ovirt.org/ovirt-dwh"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS=""
IUSE=""

COMMON_DEPEND="
	dev-java/commons-collections
	dev-java/dom4j"
DEPEND=">=virtual/jdk-1.7
	dev-java/ant
	${COMMON_DEPEND}"
RDEPEND="${PYTHON_DEPS}
	>=virtual/jre-1.7
	>=app-emulation/ovirt-engine-3.4.9999
	dev-java/jdbc-postgresql
	${COMMON_DEPEND}"

pkg_setup() {
	java-pkg-2_pkg_setup
	python_export_best EPYTHON PYTHON PYTHON_SITEDIR

	enewgroup ovirt
	enewuser ovirt -1 "" "" ovirt

	MAKE_COMMON_ARGS=" \
		PYTHON=${PYTHON} \
		PYTHON_DIR=${PYTHON_SITEDIR} \
		PREFIX=/usr \
		SYSCONF_DIR=/etc \
		LOCALSTATE_DIR=/var \
		PYTHON_SYS_DIR=${PYTHON_SITEDIR} \
		PKG_USER=ovirt \
		PKG_GROUP=ovirt \
		DISPLAY_VERSION=${PVR} \
		"
}

src_compile() {
	emake ${MAKE_COMMON_ARGS} all
}

src_install() {
	emake ${MAKE_COMMON_ARGS} DESTDIR="${ED}" install

	diropts -o ovirt -g ovirt
	keepdir /var/log/ovirt-engine-dwh
	keepdir /var/lib/ovirt-engine-dwh

	python_export_best
	find "${ED}" -executable -name '*.py' | while read f; do
		# bug#492606
		#python_replicate_script "${f}"
		sed -i "s|^#!/usr/bin/python.*|#!${PYTHON}|" "${f}"
	done
	python_optimize
	python_optimize "${ED}/usr/share/ovirt-engine"

	newinitd "${FILESDIR}/ovirt-engine-dwhd.init.d" "ovirt-engine-dwhd"
}

pkg_postinst() {
	elog "To configure package:"
	elog "    emerge --config ${CATEGORY}/ovirt-engine"
}
