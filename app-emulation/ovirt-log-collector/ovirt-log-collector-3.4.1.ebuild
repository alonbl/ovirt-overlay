# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit python-r1

DESCRIPTION="Log collector for the Open Virtualization Manager"
HOMEPAGE="http://gerrit.ovirt.org"
SRC_URI="http://resources.ovirt.org/pub/src/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="${PYTHON_DEPS}
	>=dev-python/python-exec-0.3"
DEPEND="${RDEPEND}
	sys-devel/gettext"

src_prepare() {
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
		python_export ${EPYTHON} PYTHON_SITEDIR
		python_replicate_script "${ED}${PYTHON_SITEDIR}/ovirt_log_collector/__main__.py"
		python_optimize
	}
	python_foreach_impl run_in_build_dir inst
}

run_in_build_dir() {
	pushd "${BUILD_DIR}" > /dev/null
	"$@"
	popd > /dev/null
}
