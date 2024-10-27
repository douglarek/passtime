# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

APPIMAGE="${P}-x86_64.AppImage"

inherit desktop xdg

DESCRIPTION="Cursor App - AI-first coding environment"
HOMEPAGE="https://www.cursor.com/"
SRC_URI="https://download.todesktop.com/230313mzl4w4u92/cursor-0.42.3-build-241016kxu9umuir-x86_64.AppImage -> ${APPIMAGE}"

LICENSE="cursor"

SLOT="0"
KEYWORDS="-* amd64"

RESTRICT="strip bindist"

RDEPEND="sys-fs/fuse"
DEPEND="${RDEPEND}"

QA_PREBUILT="*"

src_unpack() {
	mkdir -p "${S}" || die
	cp "${DISTDIR}/${APPIMAGE}" "${S}" || die

	cd "${S}" || die
	chmod +x "${S}/${APPIMAGE}" || die
	"${S}/${APPIMAGE}" --appimage-extract || die
}

src_prepare() {
	# Fix permissions.
	find "${S}" -type d -exec chmod a+rx {} + || die
	find "${S}" -type f -exec chmod a+r {} + || die

	default
}

src_install() {
	cd "${S}/squashfs-root" || die

	insinto /usr/share
	doins -r ./usr/share/icons

	local apphome="/opt/${PN}"
	local toremove=(
		.DirIcon
		cursor.desktop
		cursor.png
		AppRun
		LICENSE.electron.txt
		LICENSES.chromium.html
		usr
	)
	rm -f -r "${toremove[@]}" || die

	mkdir -p "${ED}/${apphome}" || die
	cp -r . "${ED}/${apphome}" || die

	dosym -r "${apphome}/cursor" "/usr/bin/${PN}"
	make_desktop_entry "${PN} --no-sandbox %U" Cursor cursor "Utility;" \
		"X-AppImage-Version=${PV}\nMimeType=x-scheme-handler/cursor;"
}
