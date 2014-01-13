# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
PYTHON_COMPAT=( python{2_6,2_7,3_1,3_2,3_3} )

inherit python-r1 java-pkg-opt-2

DESCRIPTION="oVirt Host Deploy"
HOMEPAGE="http://www.ovirt.org"
SRC_URI="http://resources.ovirt.org/releases/3.3/src/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="${PYTHON_DEPS}
	app-emulation/otopi[${PYTHON_USEDEP}]
	java? ( >=virtual/jre-1.5 )"
DEPEND="${RDEPEND}
	sys-devel/gettext
	dev-python/pep8
	dev-python/pyflakes
	java? ( >=virtual/jdk-1.5 )"

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
		python_optimize "${ED}/usr/share/ovirt-host-deploy/plugins"
	}
	python_foreach_impl run_in_build_dir inst

	use java && java-pkg_newjar target/${PN}*.jar ${PN}.jar
	dodoc README*
}

run_in_build_dir() {
	pushd "${BUILD_DIR}" > /dev/null
	"$@"
	popd > /dev/null
}
