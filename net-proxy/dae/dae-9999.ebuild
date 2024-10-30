# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic linux-info git-r3 go-module systemd

DESCRIPTION="A lightweight and high-performance transparent proxy solution based on eBPF"
HOMEPAGE="https://github.com/daeuniverse/dae"
SRC_URI="https://github.com/Loyalsoldier/v2ray-rules-dat/releases/download/202410292212/geoip.dat
	https://github.com/Loyalsoldier/v2ray-rules-dat/releases/download/202410292212/geosite.dat
"


LICENSE="AGPL-3"
SLOT="0"
MINKV="5.8"

EGIT_REPO_URI="https://github.com/daeuniverse/dae.git"

BDEPEND="sys-devel/clang app-arch/unzip"

pkg_pretend() {
	local CONFIG_CHECK="~DEBUG_INFO_BTF ~NET_CLS_ACT ~NET_SCH_INGRESS ~NET_INGRESS ~NET_EGRESS"

	if kernel_is -lt ${MINKV//./ }; then
		ewarn "Kernel version at least ${MINKV} required"
	fi

	check_extra_config
}

src_unpack() {
	git-r3_src_unpack
	cd "${P}" || die
	ego mod download -modcacherw
}

src_prepare() {
	# Prevent conflicting with the user's flags
	# https://devmanual.gentoo.org/ebuild-writing/common-mistakes/#-werror-compiler-flag-not-removed
	sed -i -e 's/-Werror//' "${S}/Makefile" || die 'Failed to remove -Werror via sed'

	default
}

src_compile() {
	# for dae's ebpf target
	# gentoo-zh#3720
	filter-flags "-march=*" "-mtune=*"
	append-cflags "-fno-stack-protector"

	local GIT_VER=$(git describe --tags --long | sed 's/^v//;s/\([^-]*-g\)/r\1/;s/-\([^-]*\)-\([^-]*\)$/.\1.\2/;s/-//')
	emake VERSION="${GIT_VER}" GOFLAGS="-buildvcs=false"
}

src_install() {
	dobin dae

	systemd_dounit install/dae.service

	insinto /etc/dae
	newins example.dae config.dae.example
	newins install/empty.dae config.dae

	insinto /usr/share/dae
	doins "${DISTDIR}/geoip.dat"
	doins "${DISTDIR}/geosite.dat"
}
