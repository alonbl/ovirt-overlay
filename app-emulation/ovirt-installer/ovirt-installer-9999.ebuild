# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

SUPPORT_PYTHON_ABIS="1"
PYTHON_DEPEND="*"
inherit python java-pkg-opt-2
inherit git-2 autotools

DESCRIPTION="ovirt-installer"
HOMEPAGE="http://www.ovirt.org"
EGIT_REPO_URI="git://git.engineering.redhat.com/users/abarlev/${PN}.git"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="-*"
IUSE=""

RDEPEND="sys-devel/gettext
	java? (
		>=virtual/jre-1.4
		dev-java/commons-logging
	)
"
DEPEND="${RDEPEND}
	dev-python/pep8
	dev-python/pyflakes
	java? (
		>=virtual/jdk-1.4
		dev-java/junit:4
	)
"

pkg_setup() {
	python_pkg_setup
	java-pkg-opt-2_pkg_setup
}

src_prepare() {
	eautoreconf
	python_copy_sources
}

src_configure() {
	conf() {
		econf \
			$(use_enable java java-sdk) \
			COMMONS_LOGGING_JAR=$(java-pkg_getjar commons-logging \
				commons-logging.jar) \
			JUNIT_JAR=$(java-pkg_getjar --build-only junit-4 junit.jar)
	}
	python_execute_function -s conf
}

src_compile() {
	python_execute_function -d -s
}

src_install() {
	inst() {
		emake install DESTDIR="${D}"

		if use java; then
			java-pkg_dojar target/ovirt-installer-*.jar
			java-pkg_dojar target/vdsm-bootstrap-*.jar
		fi
		dodoc README*
	}
	python_execute_function -s inst
	python_clean_installation_image
}

pkg_postinst() {
	local share=share # hack python eclass
	python_mod_optimize ovirt_installer vdsm_bootstrap
	python_mod_optimize --allow-evaluated-non-sitedir-paths \
		/usr/\${share}/ovirt-installer/plugins
}

pkg_postrm() {
	local share=share # hack python eclass
	python_mod_cleanup ovirt_installer vdsm_bootstrap
	python_mod_cleanup --allow-evaluated-non-sitedir-paths \
		/usr/\${share}/ovirt-installer/plugins
}
