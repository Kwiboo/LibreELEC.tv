# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Lukas Rusak (lrusak@libreelec.tv)
# Copyright (C) 2019-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="qtserialport"
PKG_VERSION="5.14.0"
PKG_SHA256="4b647a66ae4da6b05b41b49ed296012002c1951f8a3ee24e0f2aa493f48e1ed3"
PKG_LICENSE="GPL"
PKG_SITE="http://qt-project.org"
PKG_URL="http://download.qt.io/archive/qt/${PKG_VERSION%.*}/$PKG_VERSION/submodules/$PKG_NAME-everywhere-src-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="qtbase"
PKG_LONGDESC="A cross-platform application and UI framework."
PKG_TOOLCHAIN="configure"
PKG_BUILD_FLAGS="-sysroot"

configure_target() {
  qmake
}
