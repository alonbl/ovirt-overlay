# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit java-pkg-2
inherit git-2 autotools

DESCRIPTION="vdsm json rpc client"
HOMEPAGE="http://www.ovirt.org"
EGIT_REPO_URI="git://gerrit.ovirt.org/${PN}.git"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="${PYTHON_DEPS}
	>=virtual/jre-1.5
	dev-java/jackson
	dev-java/jackson-mapper
"
DEPEND="${RDEPEND}
	>=virtual/jdk-1.5
	dev-java/junit:4
"

src_prepare() {
	eautoreconf
	export COMMONS_LOGGING_JAR="$(java-pkg_getjar commons-logging commons-logging.jar)"
	export JACKSON_CORE_ASL="$(java-pkg_getjar jackson jackson.jar)"
	export JACKSON_MAPPER_ASL="$(java-pkg_getjar jackson-mapper jackson-mapper.jar)"
}

src_compile() {
	default
}

src_install() {
	java-pkg_newjar target/${PN}*.jar ${PN}.jar
}
