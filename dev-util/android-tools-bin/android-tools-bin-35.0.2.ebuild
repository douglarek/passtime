# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Android platform tools (adb, fastboot)"
HOMEPAGE="
	https://developer.android.com/
"
SRC_URI="https://dl.google.com/android/repository/platform-tools_r${PV}-linux.zip"
S="${WORKDIR}/platform-tools"

LICENSE="Apache-2.0 BSD-2"
SLOT="0"
KEYWORDS="-* ~amd64"
RESTRICT="bindist strip"

DEPEND=""
RDEPEND="${DEPEND}"

src_install() {
	exeinto /opt/${PN}
	doexe adb fastboot
	dosym ../${PN}/adb /opt/bin/adb
	dosym ../${PN}/fastboot /opt/bin/fastboot
}
