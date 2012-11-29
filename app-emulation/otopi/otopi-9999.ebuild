# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

SUPPORT_PYTHON_ABIS="1"
PYTHON_DEPEND="*"
inherit python java-pkg-opt-2
inherit git-2 autotools

DESCRIPTION="OVirt Task Oriented Pluggable Installer/Implementation"
HOMEPAGE="http://www.ovirt.org"
EGIT_REPO_URI="git://gerrit.ovirt.org/${PN}.git"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS=""
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
		local extra_conf
		if use java; then
			export COMMONS_LOGGING_JAR="$(java-pkg_getjar commons-logging \
					commons-logging.jar)"
			export JUNIT_JAR="$(java-pkg_getjar --build-only junit-4 junit.jar)"
		fi
		econf \
			$(use_enable java java-sdk) \
			${extra_conf}
	}
	python_execute_function -s conf
}

src_compile() {
	python_execute_function -d -s
}

src_install() {
	inst() {
		emake install DESTDIR="${D}"

		use java && java-pkg_dojar target/${PN}*.jar
		dodoc README*
	}
	python_execute_function -s inst
	python_clean_installation_image
}

pkg_postinst() {
	local share=share # hack python eclass
	python_mod_optimize ${PN}
	python_mod_optimize --allow-evaluated-non-sitedir-paths \
		/usr/\${share}/${PN}/plugins
}

pkg_postrm() {
	local share=share # hack python eclass
	python_mod_cleanup ${PN}
	python_mod_cleanup --allow-evaluated-non-sitedir-paths \
		/usr/\${share}/${PN}/plugins
}
