# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"
PYTHON_DEPEND="2:2.7"

inherit eutils java-pkg-2 git-2 python

DESCRIPTION="oVirt Engine"
HOMEPAGE="http://www.ovirt.org"
EGIT_REPO_URI="git://gerrit.ovirt.org/ovirt-engine"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS=""
IUSE="+system-jars minimal"

MAVEN_SLOT="3.0"
MAVEN="mvn-${MAVEN_SLOT}"
JBOSS_HOME="/usr/share/ovirt/jboss"

JARS="
	dev-java/antlr
	dev-java/aopalliance
	dev-java/c3p0
	dev-java/commons-beanutils
	dev-java/commons-codec
	dev-java/commons-collections
	dev-java/commons-compress
	dev-java/commons-httpclient
	dev-java/commons-lang
	dev-java/dom4j
	dev-java/httpcomponents-client-bin
	dev-java/istack-commons-runtime
	dev-java/jaxb
	dev-java/jaxb-tools
	dev-java/jdbc-postgresql
	dev-java/jettison
	dev-java/jsch
	dev-java/log4j
	dev-java/slf4j-api
	dev-java/snakeyaml
	dev-java/stax
	dev-java/validation-api
	dev-java/ws-commons-util
	app-emulation/ovirt-host-deploy[java]
	"

DEPEND=">=virtual/jdk-1.7
	dev-java/maven-bin:${MAVEN_SLOT}
	app-arch/unzip
	${JARS}"
RDEPEND=">=virtual/jre-1.7
	app-emulation/ovirt-jboss-as-bin
	dev-db/postgresql-server[uuid]
	virtual/cron
	dev-libs/openssl
	app-arch/gzip
	net-dns/bind-tools
	sys-libs/cracklib[python]
	${JARS}"

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup
	java-pkg-2_pkg_setup

	enewgroup ovirt
	enewuser ovirt -1 "" "" ovirt,postgres

	export MAVEN_OPTS="-Djava.io.tmpdir=${T} \
		-Dmaven.repo.local=$(echo ~portage)/${PN}-maven-repository"

	# TODO: we should be able to disable pom install
	MAVEN_MAKE_COMMON=" \
		MVN=mvn-${MAVEN_SLOT} \
		PYTHON=$(PYTHON --absolute-path) \
		PYTHON_DIR=$(python_get_sitedir) \
		PREFIX=/usr \
		SYSCONF_DIR=/etc \
		MAVENPOM_DIR=/tmp \
		JAVA_DIR=/usr/share/${PN}/java \
		EXTRA_BUILD_FLAGS=$(use minimal && echo "-Dgwt.userAgent=gecko1_8")"
}

src_compile() {
	emake -j1 \
		${MAVEN_MAKE_COMMON} \
		all \
		|| die
}

src_install() {
	emake -j1 \
		${MAVEN_MAKE_COMMON} \
		DESTDIR="${ED}" \
		install \
		|| die

	# remove the pom files
	rm -fr "${ED}/tmp"

	newconfd packaging/fedora/engine-service.sysconfig ovirt-engine

	# Posgresql JDBC driver is missing from maven output
	cd "${ED}/usr/share/ovirt-engine/engine.ear/lib"
	java-pkg_jar-from jdbc-postgresql
	cd "${S}"

	if use system-jars; then
		# TODO: we still have binaries
		cd "${ED}/usr/share/ovirt-engine/engine.ear/lib"
		while read dir package; do
			rm -f ${dir}*.jar
			java-pkg_jar-from "${package}"
		done << __EOF__
commons-httpclient commons-httpclient-3
antlr antlr
aopalliance aopalliance-1
c3p0 c3p0
commons-beanutils commons-beanutils-1.7
commons-codec commons-codec
commons-compress commons-compress
commons-collections commons-collections
commons-lang commons-lang-2.1
dom4j dom4j-1
jaxb jaxb-2
jsch jsch
slf4j-api slf4j-api 
stax stax
validation-api validation-api-1.0
ws-commons-util ws-commons-util
otopi otopi
ovirt-host-deploy ovirt-host-deploy
__EOF__
		# TODO: we still have binaries
		cd "${ED}/usr/share/ovirt-engine/engine.ear/restapi.war/WEB-INF/lib"
		while read dir package; do
			rm -f ${dir}*.jar
			java-pkg_jar-from "${package}"
		done << __EOF__
commons-codec commons-codec
log4j log4j
snakeyaml snakeyaml
__EOF__
		cd "${S}"
	fi

	# TODO:
	# the following should move
	# from make to spec
	# for now just remove them
	# postgres was installed at lib of ear
	rm -fr \
		"${ED}/etc/tmpfiles.d" \
		"${ED}/etc/rc.d" \
		"${ED}/etc/sysconfig" \
		"${ED}/lib/systemd" \
		"${ED}/usr/share/ovirt-engine/modules"

	fowners ovirt:ovirt -R /etc/ovirt-engine
	fowners ovirt:ovirt -R /etc/pki/ovirt-engine

	diropts -o ovirt -g ovirt
	keepdir /var/log/ovirt-engine/{notifier,engine-manage-domains}
	keepdir /var/lib/ovirt-engine/{deployments,content}
	keepdir /var/cache/ovirt-engine
	keepdir /var/lock/ovirt-engine

	python_convert_shebangs -r 2 "${ED}"
}
