# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake xdg

DESCRIPTION="An unintrusive minimal image viewer"
HOMEPAGE="https://github.com/dheerajshenoy/iv"

IV_COMMIT="793d4a5fecf0edf3c006f8429b05d96376a644f5"
SRC_URI="https://github.com/dheerajshenoy/iv/archive/${IV_COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/iv-${IV_COMMIT}"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="avif exif"

DEPEND="
	dev-qt/qtbase:6[gui,sql,widgets]
	media-gfx/imagemagick[cxx]
	avif? ( media-libs/libavif )
	exif? ( media-gfx/exiv2 )
"
RDEPEND="${DEPEND}"
BDEPEND="
	dev-build/cmake
	virtual/pkgconfig
"

src_configure() {
	cmake_src_configure
}
