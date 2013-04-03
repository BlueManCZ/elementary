# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

VALA_MIN_API_VERSION=0.16

inherit gnome2-utils vala cmake-utils bzr

DESCRIPTION="The terminal of the 21st century"
HOMEPAGE="https://launchpad.net/pantheon-terminal"
EBZR_REPO_URI="lp:pantheon-terminal"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE="nls"

RDEPEND="
	dev-libs/glib:2
	x11-libs/granite
	x11-libs/libnotify
	x11-libs/gtk+:3
	x11-libs/vte:2.90"
DEPEND="${RDEPEND}
	$(vala_depend)
	nls? ( sys-devel/gettext )
	virtual/pkgconfig"

pkg_setup() {
	DOCS=( AUTHORS README )
}

src_prepare() {
	use nls || sed -i 's/add_subdirectory (po)//' CMakeLists.txt

	cmake-utils_src_prepare
	vala_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DGSETTINGS_COMPILE=OFF
		-DVALA_EXECUTABLE="${VALAC}"
	)

	cmake-utils_src_configure
}

pkg_preinst() {
	gnome2_schemas_savelist
}

pkg_postinst() {
	gnome2_schemas_update
}

pkg_postrm() {
	gnome2_schemas_update
}
