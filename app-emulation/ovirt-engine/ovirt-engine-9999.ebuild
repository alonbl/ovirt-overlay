# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
PYTHON_COMPAT=( python2_7 )

CHECKREQS_MEMORY="8G"

inherit user java-pkg-2 git-2 python-r1 check-reqs

DESCRIPTION="oVirt Engine"
HOMEPAGE="http://www.ovirt.org"
#EGIT_REPO_URI="git://gerrit.ovirt.org/ovirt-engine"
EGIT_REPO_URI="git://gerrit.ovirt.org/ovirt-engine"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS=""
IUSE="+system-jars minimal +novnc"

MAVEN_SLOT="3.0"
MAVEN="mvn-${MAVEN_SLOT}"
JBOSS_HOME="/usr/share/ovirt/jboss-as"

JARS="
	dev-java/jdbc-postgresql
	system-jars? (
		app-emulation/otopi[java]
		app-emulation/ovirt-host-deploy[java]
		dev-java/aopalliance
		dev-java/apache-sshd-bin
		dev-java/commons-beanutils
		dev-java/commons-codec
		dev-java/commons-collections
		dev-java/commons-compress
		dev-java/commons-configuration
		dev-java/commons-httpclient
		dev-java/commons-jxpath
		dev-java/commons-lang
		dev-java/hibernate-validator-bin
		dev-java/jaxb
		dev-java/quartz-bin
		dev-java/slf4j-api
		dev-java/spring-framework-bin
		dev-java/spring-ldap-bin
		dev-java/stax
		dev-java/validation-api
		dev-java/xml-commons
		dev-java/xmlrpc-client-bin
		dev-java/xz-java
	)
	"

DEPEND=">=virtual/jdk-1.7
	dev-java/maven-bin:${MAVEN_SLOT}
	app-arch/unzip
	${JARS}"
RDEPEND="${PYTHON_DEPS}
	>=app-emulation/otopi-1.0.2
	>=dev-python/python-exec-0.3
	>=virtual/jre-1.7
	app-emulation/ovirt-host-deploy
	app-emulation/ovirt-jboss-as-bin
	dev-db/postgresql-base
	dev-libs/libxml2[python]
	dev-libs/openssl
	dev-python/cheetah
	dev-python/m2crypto
	dev-python/psycopg
	dev-python/python-daemon
	net-dns/bind-tools
	sys-libs/cracklib[python]
	www-servers/apache[apache2_modules_headers,apache2_modules_proxy_ajp,ssl]
	novnc? (
		dev-python/websockify
		www-misc/noVNC
	)
	${JARS}"

# for the unneeded custom logrotate: ovirtlogrot.sh
RDEPEND="${RDEPEND}
	virtual/cron
	app-arch/xz-utils"

pkg_setup() {
	java-pkg-2_pkg_setup
	python_export_best EPYTHON PYTHON PYTHON_SITEDIR

	enewgroup ovirt
	enewuser ovirt -1 "" "" ovirt
	enewuser vdsm -1 "" "" kvm

	export MAVEN_OPTS="-Djava.io.tmpdir=${T} \
		-Dmaven.repo.local=$(echo ~portage)/${PN}-maven-repository"

	# TODO: we should be able to disable pom install
	MAKE_COMMON_ARGS=" \
		MVN=mvn-${MAVEN_SLOT} \
		PYTHON=${PYTHON} \
		PYTHON_DIR=${PYTHON_SITEDIR} \
		PREFIX=/usr \
		SYSCONF_DIR=/etc \
		PKG_PKI_DIR=/etc/ovirt-engine/pki \
		LOCALSTATE_DIR=/var \
		MAVENPOM_DIR=/tmp \
		JAVA_DIR=/usr/share/${PN}/java \
		PKG_USER=ovirt \
		PKG_GROUP=ovirt \
		EXTRA_BUILD_FLAGS=$(use minimal && echo "-Dgwt.userAgent=gecko1_8") \
		BUILD_LOCALES=$(use minimal && echo 0 || echo 1) \
		DISPLAY_VERSION=${PVR} \
		"
}

src_prepare() {
	rm -f packaging/conf/ovirt-websocket-proxy.conf.defaults
}

src_compile() {
	emake -j1 \
		${MAKE_COMMON_ARGS} \
		all \
		|| die
}

src_install() {
	emake -j1 \
		${MAKE_COMMON_ARGS} \
		DESTDIR="${ED}" \
		install \
		|| die

	# remove the pom files
	rm -fr "${ED}/tmp"

	if use system-jars; then
		find "${ED}/usr/share/ovirt-engine/engine.ear" -name 'lib' | \
		while read lib; do
			cd "${lib}"
			while read name package; do
				[ -z "${package}" ] && package="${name}"
				if [ "$(find . -name "${name}*.jar" | wc -l)" != 0 ]; then
					rm -f "${name}"*.jar
					java-pkg_jar-from --with-dependencies "${package}"
				fi
			done << __EOF__
commons-lang commons-lang-2.1
__EOF__
			cd "${S}"
		done

		find "${ED}/usr/share/ovirt-engine/modules" -name module.xml | \
		while read module; do
			cd "$(dirname "${module}")"
			while read current package name; do
				[ -z "${package}" ] && package="${current}"
				if grep -q "<resource-root path=\"${current}" module.xml; then
					rm -f ${current}*.jar
					java-pkg_jar-from ${package//:/ }
					if ! [ -e "${current}.jar" ]; then
						if [ -n "${name}" ]; then
							ln -s ${name}.jar "${current}.jar"
						elif [ "${current}" != "${package}" ]; then
							ln -s "${package}.jar" "${current}.jar"
						fi
					fi
				fi
			done << __EOF__
commons-compress
commons-configuration
commons-httpclient commons-httpclient-3
commons-jxpath
mina-core apache-mina-bin-4
otopi otopi otopi*
ovirt-host-deploy ovirt-host-deploy ovirt-host-deploy*
postgresql jdbc-postgresql
quartz quartz-bin-4
slf4j-api
spring-aop spring-framework-bin-4:spring-aop.jar
spring-asm spring-framework-bin-4:spring-core.jar spring-core
spring-beans spring-framework-bin-4:spring-beans.jar
spring-context spring-framework-bin-4:spring-context.jar
spring-core spring-framework-bin-4:spring-core.jar
spring-expression spring-framework-bin-4:spring-expression.jar
spring-instrument spring-framework-bin-4:spring-instrument.jar
spring-jdbc spring-framework-bin-4:spring-jdbc.jar
spring-tx spring-framework-bin-4:spring-tx.jar
spring-ldap-core spring-ldap-bin-4:spring-ldap-core.jar
sshd-core apache-sshd-bin-4
ws-commons-util
xmlrpc-client xmlrpc-client-bin-4
__EOF__
		cd "${S}"
		done
	fi

	# TODO:
	# the following should move
	# from make to spec
	# for now just remove them
	# postgres was installed at lib of ear
	rm -fr \
		"${ED}/etc/tmpfiles.d" \
		"${ED}/etc/rc.d" \
		"${ED}/lib/systemd"

	# install only 2nd generation setup
	for f in engine-setup engine-cleanup; do
		rm "${ED}/usr/bin/${f}"
		dosym "${f}-2" "/usr/bin/${f}"
	done

	fowners ovirt:ovirt /etc/ovirt-engine/pki/{,certs,requests,private}

	diropts -o ovirt -g ovirt
	keepdir /var/log/ovirt-engine/{,notifier,engine-manage-domains,host-deploy}
	keepdir /var/lib/ovirt-engine/{,deployments,content}
	keepdir /var/cache/ovirt-engine

	#
	# Force TLS/SSL for selected applications.
	#
	for war in restapi userportal webadmin; do
		sed -i \
			-e 's#<transport-guarantee>NONE</transport-guarantee>#<transport-guarantee>CONFIDENTIAL</transport-guarantee>#' \
			"${ED}/usr/share/ovirt-engine/engine.ear/${war}.war/WEB-INF/web.xml"
	done

	python_export_best
	find "${ED}" -executable -name '*.py' | while read f; do
		python_replicate_script "${f}"
	done
	python_optimize
	python_optimize "${ED}/usr/share/ovirt-engine"

	newinitd "${FILESDIR}/ovirt-engine.init.d" "ovirt-engine"
	use novnc && newinitd "${FILESDIR}/ovirt-websocket-proxy.init.d" "ovirt-websocket-proxy"
	insinto /etc/ovirt-engine-setup.conf.d
	newins "${FILESDIR}/gentoo-setup.conf" "01-gentoo.conf"
	insinto /etc/ovirt-engine-setup.env.d
	newins "${FILESDIR}/gentoo-setup.env" "01-gentoo.env"

	if use system-jars; then
		WHITE_LIST="\
bll.jar|\
common.jar|\
compat.jar|\
dal.jar|\
frontend.jar|\
gwt-extension.jar|\
gwt-servlet.jar|\
interface-common-jaxrs.jar|\
restapi-definition.jar|\
restapi-jaxrs.jar|\
restapi-types.jar|\
scheduler.jar|\
searchbackend.jar|\
tools.jar|\
utils.jar|\
vdsbroker.jar\
"
		BLACK_LIST_JARS="$(
			find "${ED}" -name '*.jar' -type f | \
			xargs -n1 basename -- | sort | uniq | \
			grep -v -E "${WHITE_LIST}" \
		)"
	fi
}

pkg_postinst() {
	if use system-jars && [ -n "${BLACK_LIST_JARS}" ]; then
		ewarn "system-jars was selected, however, these componets still binary:"
		ewarn "$(echo "${BLACK_LIST_JARS}" | sed 's/^/\t/')"
	fi

	ewarn "You should enable proxy by adding the following to /etc/conf.d/apache2"
	ewarn '   APACHE2_OPTS="${APACHE2_OPTS} -D PROXY"'

	elog "To configure package:"
	elog "    emerge --config =${CATEGORY}/${PF}"
}

pkg_config() {
	/usr/bin/engine-setup
}
