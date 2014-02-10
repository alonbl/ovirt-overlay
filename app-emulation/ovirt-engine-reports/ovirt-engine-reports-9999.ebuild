# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit user java-pkg-2 python-r1
inherit git-2

DESCRIPTION="oVirt Engine Reports"
HOMEPAGE="http://www.ovirt.org"
EGIT_REPO_URI="git://gerrit.ovirt.org/ovirt-reports"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND=">=virtual/jdk-1.7
	dev-java/ant
	www-apps/jasperreports-server-bin"
RDEPEND="${PYTHON_DEPS}
	>=app-emulation/ovirt-engine-9999
	>=virtual/jre-1.7
	sys-devel/patch
	dev-libs/libxml2[python]
	sys-libs/cracklib[python]
	www-apps/jasperreports-server-bin
	"

pkg_setup() {
	java-pkg-2_pkg_setup
	python_export_best EPYTHON PYTHON PYTHON_SITEDIR

	enewgroup ovirt
	enewuser ovirt -1 "" "" ovirt

	# TODO: we should be able to disable pom install
	MAKE_COMMON_ARGS=" \
		PYTHON=${PYTHON} \
		PYTHON_DIR=${PYTHON_SITEDIR} \
		PREFIX=/usr \
		SYSCONF_DIR=/etc \
		LOCALSTATE_DIR=/var \
		PKG_JAVA_DIR=/usr/share/${PN}/lib \
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
	keepdir /var/log/ovirt-engine-reports
	keepdir /var/lib/ovirt-engine-reports

	python_export_best
	find "${ED}" -executable -name '*.py' | while read f; do
		# bug#492606
		#python_replicate_script "${f}"
		sed -i "s|^#!/usr/bin/python.*|#!${PYTHON}|" "${f}"
	done
	python_optimize
	python_optimize "${ED}/usr/share/ovirt-engine"

	insinto /etc/ovirt-engine-setup.conf.d
	newins "${FILESDIR}/gentoo-setup.conf" "01-gentoo-reports.conf"
}

pkg_postinst() {
	elog "To configure package:"
	elog "    emerge --config ${CATEGORY}/ovirt-engine"
}
