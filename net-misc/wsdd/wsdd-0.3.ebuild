# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit user

DESCRIPTION="A Web Service Discovery host daemon."
HOMEPAGE="https://github.com/christgau/wsdd"
SRC_URI="https://github.com/christgau/wsdd/archive/v0.3.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="samba"

DEPEND=""
# Samba is technically no requiredment of wsdd, but depend on
# it if the use flags is set.
RDEPEND="${DEPEND} samba? ( net-fs/samba )"
BDEPEND=""

src_install() {
	# maybe python_newscript from python-utils-r1.eclass is better
	newbin src/wsdd.py wsdd

	# replace generic daemon:daemon with wsdd account
	sed -i -e 's/daemon:daemon/wsdd:wsdd/g' etc/openrc/wsdd

	# remove dependency on samba from init.d script if samba is not in use flags
	if ! use samba ; then
		sed -i -e '/need samba/d' etc/openrc/wsdd
	fi

	doinitd etc/openrc/wsdd

	dodoc README.md
}

pkg_postinst() {
	enewuser wsdd -1 -1 /dev/null daemon
}
