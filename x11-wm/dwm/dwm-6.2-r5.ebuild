# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit git-r3 toolchain-funcs

DESCRIPTION="A fork of Suckless DWM, heavily tweaked and patched"

HOMEPAGE="https://github.com/yad-tahir/dwm"
EGIT_REPO_URI="https://github.com/yad-tahir/dwm.git"
EGIT_COMMIT="patched-6.2.5"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="xinerama"

RDEPEND="
	media-libs/fontconfig
	x11-libs/libX11
	x11-libs/libXft
	xinerama? ( x11-libs/libXinerama )
"
DEPEND="
	${RDEPEND}
	xinerama? ( x11-base/xorg-proto )
"

src_prepare() {
	default

	sed -i \
		-e "s/ -Os / /" \
		-e "/^\(LDFLAGS\|CFLAGS\|CPPFLAGS\)/{s| = | += |g;s|-s ||g}" \
		config.mk || die
}

src_compile() {
	if use xinerama; then
		emake CC=$(tc-getCC) dwm
	else
		emake CC=$(tc-getCC) XINERAMAFLAGS="" XINERAMALIBS="" dwm
	fi
}

src_install() {
	emake DESTDIR="${D}" PREFIX="${EPREFIX}/usr" install

	insinto /usr/share/xsessions
	doins "${FILESDIR}"/dwm.desktop

	dodoc README
}
