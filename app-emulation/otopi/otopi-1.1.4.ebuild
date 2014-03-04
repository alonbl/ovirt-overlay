# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
PYTHON_COMPAT=( python{2_6,2_7,3_1,3_2,3_3} )

inherit python-r1 java-pkg-opt-2

DESCRIPTION="oVirt Task Oriented Pluggable Installer/Implementation"
HOMEPAGE="http://www.ovirt.org"
SRC_URI="http://resources.ovirt.org/releases/3.3/src/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="${PYTHON_DEPS}
	java? (
		>=virtual/jre-1.5
		dev-java/commons-logging
	)
"
DEPEND="${RDEPEND}
	sys-devel/gettext
	dev-python/pep8
	dev-python/pyflakes
	java? (
		>=virtual/jdk-1.5
		dev-java/junit:4
	)
"

src_prepare() {
	python_copy_sources
}

src_configure() {
	conf() {
		econf --with-local-version="${PF}"
	}
	python_foreach_impl run_in_build_dir conf

	if use java; then
		python_export_best
		export COMMONS_LOGGING_JAR="$(java-pkg_getjar commons-logging \
				commons-logging.jar)"
		export JUNIT_JAR="$(java-pkg_getjar --build-only junit-4 junit.jar)"
		econf \
			$(use_enable java java-sdk)
	fi
}

src_compile() {
	python_foreach_impl run_in_build_dir default

	use java && default
}

src_install() {
	inst() {
		emake install DESTDIR="${ED}" am__py_compile=true
		python_optimize
		python_optimize "${ED}/usr/share/otopi/plugins"
	}
	python_foreach_impl run_in_build_dir inst

	if use java; then
		java-pkg_register-dependency commons-logging
		java-pkg_newjar target/${PN}*.jar ${PN}.jar
	fi
	dodoc README*
}

run_in_build_dir() {
	pushd "${BUILD_DIR}" > /dev/null
	"$@"
	popd > /dev/null
}
