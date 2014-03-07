# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
EANT_BUILD_TARGET="rebuild"

inherit java-pkg-2 java-ant-2

DESCRIPTION="Object Oriented SNMP Implementation for Java"
SRC_URI="https://oosnmp.net/dist/release/org/${PN}/${PN}/${PV}/${P}-distribution.zip"
HOMEPAGE="http://www.snmp4j.org"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND=">=virtual/jdk-1.7
	dev-java/log4j"
DEPEND="${RDEPEND}"

src_prepare() {
	epatch "${FILESDIR}/${P}-build.patch"
	rm -rf dist/
	mkdir lib
	java-pkg_jar-from --into lib log4j log4j.jar log4j-1.2.14.jar
	java-pkg-2_src_prepare
}

src_compile() {
	java-pkg-2_src_compile
}

src_install() {
	java-pkg_newjar dist/lib/SNMP4J.jar ${PN}.jar
}
