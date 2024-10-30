# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic linux-info go-module systemd

_MY_PV=${PV/_rc/rc}

DESCRIPTION="A lightweight and high-performance transparent proxy solution based on eBPF"
HOMEPAGE="https://github.com/daeuniverse/dae"
SRC_URI="
	https://github.com/daeuniverse/dae/releases/download/v${_MY_PV}/dae-full-src.zip -> ${P}.zip
	https://cdn.jsdelivr.net/gh/Loyalsoldier/v2ray-rules-dat@release/geoip.dat
	https://cdn.jsdelivr.net/gh/Loyalsoldier/v2ray-rules-dat@release/geosite.dat
"

S="${WORKDIR}"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="amd64"
MINKV="5.8"

BDEPEND="sys-devel/clang
		app-arch/unzip"

pkg_pretend() {
	local CONFIG_CHECK="
		~BPF
		~BPF_SYSCALL
		~BPF_JIT
		~CGROUPS
		~KPROBES
		~NET_INGRESS
		~NET_EGRESS
		~NET_SCH_INGRESS
		~NET_CLS_BPF
		~NET_CLS_ACT
		~BPF_STREAM_PARSER
		~DEBUG_INFO
		~DEBUG_INFO_BTF
		~KPROBE_EVENTS
		~BPF_EVENTS
	"

	if kernel_is -lt ${MINKV//./ }; then
		ewarn "Kernel version at least ${MINKV} required"
	fi

	check_extra_config
}

src_prepare() {
	# Prevent conflicting with the user's flags
	sed -i -e 's/-O2//' "${S}/Makefile" || die 'Failed to remove -O2 via sed'
	sed -i -e 's/-Werror//' "${S}/Makefile" || die 'Failed to remove -Werror via sed'

	default
}

src_compile() {
	#-flto makes llvm-strip complains
	#llvm-strip: error: '*/control/bpf_bpfel.o': The file was not recognized as a valid object file
	filter-lto
	# for dae's ebpf target
	# gentoo-zh#3720
	filter-flags "-march=*" "-mtune=*"
	append-cflags "-fno-stack-protector"

	emake VERSION="${PV}" GOFLAGS="-buildvcs=false -w"
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
