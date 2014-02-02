# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit user java-pkg-2 python-r1
inherit git-2

DESCRIPTION="oVirt Engine Data Warehouse"
HOMEPAGE="http://www.ovirt.org"
EGIT_REPO_URI="git://gerrit.ovirt.org/ovirt-dwh"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS=""
IUSE="+system-jars"

MAVEN_SLOT="3.0"
MAVEN="mvn-${MAVEN_SLOT}"
JBOSS_HOME="/usr/share/ovirt/jboss-as"

JARS="
	dev-java/jdbc-postgresql
	"

DEPEND=">=virtual/jdk-1.7
	dev-java/maven-bin:${MAVEN_SLOT}
	app-arch/unzip
	${JARS}"
RDEPEND="${PYTHON_DEPS}
	>=virtual/jre-1.7
	>=app-emulation/ovirt-engine-9999
	app-emulation/ovirt-jboss-as-bin
	${JARS}"

pkg_setup() {
	java-pkg-2_pkg_setup
	python_export_best EPYTHON PYTHON PYTHON_SITEDIR

	enewgroup ovirt
	enewuser ovirt -1 "" "" ovirt

	export MAVEN_OPTS="-Djava.io.tmpdir=${T} \
		-Dmaven.repo.local=$(echo ~portage)/${PN}-maven-repository"

	# TODO: we should be able to disable pom install
	MAKE_COMMON_ARGS=" \
		MVN=mvn-${MAVEN_SLOT} \
		PYTHON=${PYTHON} \
		PYTHON_DIR=${PYTHON_SITEDIR} \
		PREFIX=/usr \
		SYSCONF_DIR=/etc \
		LOCALSTATE_DIR=/var \
		MAVENPOM_DIR=/tmp \
		JAVA_DIR=/usr/share/${PN}/java \
		PYTHON_SYS_DIR=${PYTHON_SITEDIR} \
		PKG_USER=ovirt \
		PKG_GROUP=ovirt \
		DISPLAY_VERSION=${PVR} \
		"
}

src_compile() {
	emake ${MAKE_COMMON_ARGS} all
}

src_install() {
	emake ${MAKE_COMMON_ARGS} DESTDIR="${ED}" install

	# remove the pom files
	rm -fr "${ED}/tmp"

	if use system-jars; then
		find "${ED}/usr/share/ovirt-engine-dwh/modules" -name module.xml | \
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
postgresql jdbc-postgresql
__EOF__
		cd "${S}"
		done
	fi

	diropts -o ovirt -g ovirt
	keepdir /var/log/ovirt-engine-dwh
	keepdir /var/lib/ovirt-engine-dwh

	python_export_best
	find "${ED}" -executable -name '*.py' | while read f; do
		# bug#492606
		#python_replicate_script "${f}"
		sed -i "s|^#!/usr/bin/python.*|#!${PYTHON}|" "${f}"
	done
	python_optimize
	python_optimize "${ED}/usr/share/ovirt-engine"

	newinitd "${FILESDIR}/ovirt-engine-dwhd.init.d" "ovirt-engine-dwhd"

	if use system-jars; then
		WHITE_LIST="\
advancedPersistentLookupLib.jar|\
etltermination.jar|
historyETL.jar|
routines.jar\
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

	elog "To configure package:"
	elog "    emerge --config ${CATEGORY}/ovirt-engine"
}
