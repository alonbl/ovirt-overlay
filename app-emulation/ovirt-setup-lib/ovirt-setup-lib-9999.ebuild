# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python{2_6,2_7,3_1,3_2,3_3,3_4} )

inherit git-2 autotools python-r1

DESCRIPTION="oVirt setup library"
HOMEPAGE="http://ovirt.org"
EGIT_REPO_URI="http://gerrit.ovirt.org/ovirt-setup-lib"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="${PYTHON_DEPS}"
RDEPEND="${DEPEND}"

src_prepare() {
	eautoreconf
	python_copy_sources
}

src_configure() {
	python_foreach_impl run_in_build_dir default
}

src_compile() {
	python_foreach_impl run_in_build_dir default
}

src_install() {
	inst() {
		emake install DESTDIR="${ED}" am__py_compile=true
		python_optimize
	}
	python_foreach_impl run_in_build_dir inst
}

run_in_build_dir() {
	pushd "${BUILD_DIR}" > /dev/null
	"$@"
	popd > /dev/null
}
