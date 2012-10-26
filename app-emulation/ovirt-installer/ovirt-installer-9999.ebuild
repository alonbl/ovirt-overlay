# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

SUPPORT_PYTHON_ABIS="1"
PYTHON_DEPEND="*"
inherit python git-2 autotools

DESCRIPTION="ovirt-installer"
HOMEPAGE="http://www.ovirt.org"
EGIT_REPO_URI="git://git.engineering.redhat.com/users/abarlev/${PN}.git"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="-*"
IUSE="java-sdk"

RDEPEND="sys-devel/gettext"
DEPEND="${RDEPEND}
	dev-python/pep8
	dev-python/pyflakes
"

src_prepare() {
	eautoreconf
	python_copy_sources
}

src_configure() {
	conf() {
		econf \
			$(use_enable java-sdk)
	}
	python_execute_function -s conf
}

src_compile() {
	python_execute_function -d -s
}

src_install() {
	python_execute_function -d -s
	python_clean_installation_image
	dodoc README*
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
