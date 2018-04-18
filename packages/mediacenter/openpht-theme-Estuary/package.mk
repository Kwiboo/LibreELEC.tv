################################################################################
#      This file is part of OpenELEC - http://www.openelec.tv
#      Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
#
#  OpenELEC is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 2 of the License, or
#  (at your option) any later version.
#
#  OpenELEC is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with OpenELEC.  If not, see <http://www.gnu.org/licenses/>.
################################################################################

PKG_NAME="openpht-theme-Estuary"
PKG_VERSION="1.0"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="http://www.openpht.tv"
PKG_URL=""
PKG_DEPENDS_TARGET="toolchain openpht"
PKG_NEED_UNPACK="$(get_pkg_directory $MEDIACENTER)"
PKG_SECTION="mediacenter"
PKG_SHORTDESC="openpht-theme-Estuary: OpenPHT default theme"
PKG_LONGDESC="OpenPHT is a community driven fork of Plex Home Theater"
PKG_TOOLCHAIN="manual"

makeinstall_target() {
  mkdir -p $INSTALL/usr/share/openpht/addons/
    cp -a $(get_build_dir openpht)/.$TARGET_NAME/addons/skin.estuary $INSTALL/usr/share/openpht/addons/
}
