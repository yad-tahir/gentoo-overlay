# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson virtualx xdg

DESCRIPTION="A highly customizable and functional document viewer"
HOMEPAGE="https://github.com/yad-tahir/zathura"

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/yad-tahir/${PN}.git"
	EGIT_BRANCH="master"
else
	SRC_URI="
		https://github.com/yad-tahir/zathura/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz
	"
	KEYWORDS="amd64 arm x86 ~amd64-linux ~x86-linux"
fi

LICENSE="ZLIB"
SLOT="0/$(ver_cut 1-2)"
IUSE="seccomp sqlite synctex test doc"

RESTRICT="!test? ( test )"

DEPEND=">=dev-libs/girara-0.3.7
	>=dev-libs/glib-2.50:2
	>=sys-devel/gettext-0.19.8
	x11-libs/cairo
	>=x11-libs/gtk+-3.22:3
	sys-apps/file
	seccomp? ( sys-libs/libseccomp )
	sqlite? ( >=dev-db/sqlite-3.5.9:3 )
	synctex? ( app-text/texlive-core )"

RDEPEND="${DEPEND}"

BDEPEND="
	test? ( dev-libs/appstream-glib
		dev-libs/check )
	doc? ( dev-python/sphinx )
	virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/zathura-disable-seccomp-tests.patch
)

src_configure() {
	local emesonargs=(
		-Dconvert-icon=disabled
		-Dmanpages=$(usex doc enabled disabled)
		-Dseccomp=$(usex seccomp enabled disabled)
		-Dsqlite=$(usex sqlite enabled disabled)
		-Dsynctex=$(usex synctex enabled disabled)
		)
	meson_src_configure
}

src_install() {
	meson_src_install
	if use doc; then
		doman "${WORKDIR}/${P}-build"/doc/zathura*
	fi
}

src_test() {
	virtx meson_src_test
}
