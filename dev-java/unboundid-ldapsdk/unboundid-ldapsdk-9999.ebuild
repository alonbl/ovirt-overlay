# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
SDK_VARIANT="se"
EANT_BUILD_TARGET="package"
EANT_BUILD_XML="build-${SDK_VARIANT}.xml"
JAVA_PKG_BSFIX_NAME="${EANT_BUILD_XML}"
EANT_EXTRA_ARGS="-Dcheckstyle.enabled=false"
EANT_GENTOO_CLASSPATH="ant-core"

inherit java-pkg-2 java-ant-2
inherit subversion

DESCRIPTION="UnboundID LDAP SDK for Java"
HOMEPAGE="https://www.unboundid.com/products/ldap-sdk/"
ESVN_REPO_URI="http://svn.code.sf.net/p/ldap-sdk/code/trunk"
LICENSE="|| ( GPL-2 LGPL-2.1+ UnboundID-LDAPSDK )"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND=">=virtual/jdk-1.5"
DEPEND="${RDEPEND}"

src_prepare() {
	rm -rf ext/
	java-pkg-2_src_prepare
	java-ant_rewrite-classpath "${EANT_BUILD_XML}"
}

src_compile() {
	java-pkg-2_src_compile
}

src_install() {
	java-pkg_newjar ./build/package/${PN}-*-${SDK_VARIANT}/${PN}-${SDK_VARIANT}.jar ${PN}.jar
}
