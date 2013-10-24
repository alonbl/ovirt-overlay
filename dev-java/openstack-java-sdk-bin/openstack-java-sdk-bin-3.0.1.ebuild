# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit java-utils-2

DESCRIPTION="OpenStack Java SDK"
HOMEPAGE="https://github.com/woorea/openstack-java-sdk"
SRC_URI="
	http://search.maven.org/remotecontent?filepath=com/woorea/glance-client/${PV}/glance-client-${PV}.jar
	http://search.maven.org/remotecontent?filepath=com/woorea/glance-model/${PV}/glance-model-${PV}.jar
	http://search.maven.org/remotecontent?filepath=com/woorea/keystone-client/${PV}/keystone-client-${PV}.jar
	http://search.maven.org/remotecontent?filepath=com/woorea/keystone-model/${PV}/keystone-model-${PV}.jar
	http://search.maven.org/remotecontent?filepath=com/woorea/openstack-client/${PV}/openstack-client-${PV}.jar
	http://search.maven.org/remotecontent?filepath=com/woorea/quantum-client/${PV}/quantum-client-${PV}.jar
	http://search.maven.org/remotecontent?filepath=com/woorea/quantum-model/${PV}/quantum-model-${PV}.jar
	http://search.maven.org/remotecontent?filepath=com/woorea/resteasy-connector/${PV}/resteasy-connector-${PV}.jar
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND=">=virtual/jre-1.5"

S="${WORKDIR}"

src_unpack() {
	:
}

src_install() {
	java-pkg_newjar "${DISTDIR}/glance-client-${PV}.jar" glance-client.jar
	java-pkg_newjar "${DISTDIR}/glance-model-${PV}.jar" glance-model.jar
	java-pkg_newjar "${DISTDIR}/keystone-client-${PV}.jar" keystone-client.jar
	java-pkg_newjar "${DISTDIR}/keystone-model-${PV}.jar" keystone-model.jar
	java-pkg_newjar "${DISTDIR}/openstack-client-${PV}.jar" openstack-client.jar
	java-pkg_newjar "${DISTDIR}/quantum-client-${PV}.jar" quantum-client.jar
	java-pkg_newjar "${DISTDIR}/quantum-model-${PV}.jar" quantum-model.jar
	java-pkg_newjar "${DISTDIR}/resteasy-connector-${PV}.jar" resteasy-connector.jar
}
