# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop xdg

DESCRIPTION="Manage all your JetBrains Projects and Tools"
HOMEPAGE="https://www.jetbrains.com/toolbox-app/"
SRC_URI="https://download.jetbrains.com/toolbox/${P}.tar.gz"

S=${WORKDIR}/${P}/bin

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="~amd64"

RESTRICT="strip mirror"

QA_PREBUILT="/opt/${PN}/${PN}"

src_install() {
	insinto /opt/${PN}
	cp "${FILESDIR}"/icon.svg toolbox.svg
	doins -r ./*
	fperms +x /opt/${PN}/${PN}
	fperms +x /opt/${PN}/jre/lib/jspawnhelper

	dodir /opt/${PN}
	dosym -r /opt/${PN}/${PN} /opt/bin/${PN}

	doicon "${FILESDIR}"/icon.svg
	newicon "${FILESDIR}"/icon.svg toolbox.svg

	sed -i 's/^Icon=.*/Icon=toolbox/' ${PN}.desktop
	sed -i '/^Categories=/d' ${PN}.desktop
	echo "Categories=Development;IDE;" >> ${PN}.desktop

	domenu ${PN}.desktop
}

pkg_postinst() {
	xdg_pkg_postinst
}
