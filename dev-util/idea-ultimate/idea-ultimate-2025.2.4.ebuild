# Copyright 2024 Blake LaFleur <blake.k.lafleur@gmail.com>
# Distributed under the terms of the GNU General Public License as published by the Free Software Foundation;
# either version 2 of the License, or (at your option) any later version.

EAPI=8

inherit desktop toolchain-funcs

DESCRIPTION="A cross-platform IDE for Enterprise, Web and Mobile development"
HOMEPAGE="https://www.jetbrains.com/idea/"
SRC_URI="https://download.jetbrains.com/idea/ideaIU-${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}"

LICENSE="|| ( IDEA IDEA_Academic IDEA_Classroom IDEA_OpenSource IDEA_Personal )"
LICENSE+=" 0BSD Apache-2.0 BSD BSD-2 CC0-1.0 CC-BY-2.5 CC-BY-3.0 CC-BY-4.0 CDDL-1.1 CPL-1.0 EPL-1.0 GPL-2"
LICENSE+=" GPL-2-with-classpath-exception ISC JSON LGPL-2.1 LGPL-3 LGPL-3+ libpng MIT MPL-1.1 MPL-2.0"
LICENSE+=" OFL-1.1 public-domain unicode Unlicense W3C ZLIB ZPL"

SLOT="0"
KEYWORDS="~amd64"
IUSE="wayland"

RESTRICT="strip mirror bindist"
BDEPEND="
	dev-util/debugedit
	dev-util/patchelf
"
RDEPEND="
	dev-libs/libpcre2
	sys-libs/pam
	sys-process/audit
"
#	lldb? ( llvm-core/lldb )
QA_PREBUILT="opt/${PN}/*"

src_prepare() {
	tc-export OBJCOPY
	default
	mv idea-IU-*/* . && rm -rf idea-IU-* || die

	declare -a remove_arches=(\
		arm64 \
		aarch64 \
		macos \
		windows \
		Windows \
	)

	# Remove all unsupported ARCH
	for arch in "${remove_arches[@]}"
	do
		echo "Removing files for $arch"
		find . -name "*$arch*" -exec rm -rf {} \; || true
	done

	if use wayland; then
		echo "-Dawt.toolkit.name=WLToolkit" >> bin/idea64.vmoptions

		elog "Experimental wayland support has been enabled via USE flags"
		elog "You may need to update your JBR runtime to the latest version"
		elog "https://github.com/JetBrains/JetBrainsRuntime/releases"
	fi

	#use lldb || ( rm -f plugins/Kotlin/bin/linux/LLDBFrontend && rm -rf plugins/Kotlin/bin/lldb || die )

	sed -i \
		-e "\$a\\\\" \
		-e "\$a#-----------------------------------------------------------------------" \
		-e "\$a# Disable automatic updates as these are handled through Gentoo's" \
		-e "\$a# package manager. See bug #704494" \
		-e "\$a#-----------------------------------------------------------------------" \
		-e "\$aide.no.platform.update=Gentoo" bin/idea.properties

	# removing debug symbols and relocating debug files as per #876295
	# we're escaping all the files that contain $() in their name
	# as they should not be executed
	find . -type f ! -name '*$(*)*' -print0 | while IFS= read -r -d '' file; do
		for skip in "${skip_remote_files[@]}"; do
			[[ ${file} == "./${skip}" ]] && continue 2
		done
		if file "${file}" | grep -qE "ELF (32|64)-bit"; then
			${OBJCOPY} --remove-section .note.gnu.build-id "${file}" || die
			debugedit -b "${EPREFIX}/opt/${PN}" -d "/usr/lib/debug" -i "${file}" || die
		fi
	done

	patchelf --set-rpath '$ORIGIN/../lib' "jbr/bin/"* || die
	patchelf --set-rpath '$ORIGIN' "jbr/lib/"{libjcef.so,jcef_helper} || die
	patchelf --set-rpath '$ORIGIN:$ORIGIN/server' jbr/lib/lib*.so* || die
}

src_install() {
	local dir="/opt/${PN}"
	dodir "${dir}"
	cp -r * "${D}/${dir}" || die
	dosym ../"${PN}"/bin/idea /opt/bin/"${PN}"

	newicon bin/idea.svg "${PN}".svg
	make_desktop_entry "${PN}" "IDEA Ultimate ${PVR}" "${PN}" "Development;IDE;" "StartupWMClass=jetbrains-idea"
}
