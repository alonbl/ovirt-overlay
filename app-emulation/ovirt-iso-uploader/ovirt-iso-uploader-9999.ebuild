# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit user python-r1 autotools git-2

DESCRIPTION="Upload isos to Open Virtualization Manager"
HOMEPAGE="http://gerrit.ovirt.org"
EGIT_REPO_URI="git://gerrit.ovirt.org/ovirt-iso-uploader"
EGIT_BRANCH="master"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="sys-devel/gettext
	${PYTHON_DEPS}"
DEPEND="${RDEPEND}
	app-emulation/ovirt-engine-sdk"

pkg_setup() {
	enewgroup kvm 36
	enewuser vdsm 36 -1 -1 kvm
}

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
		python_export ${EPYTHON} PYTHON_SITEDIR
		python_replicate_script "${ED}${PYTHON_SITEDIR}/ovirt_iso_uploader/__main__.py"
		python_optimize
	}
	python_foreach_impl run_in_build_dir inst
}

run_in_build_dir() {
	pushd "${BUILD_DIR}" > /dev/null
	"$@"
	popd > /dev/null
}
