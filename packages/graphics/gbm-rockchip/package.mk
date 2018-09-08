# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2018-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="gbm-rockchip"
PKG_VERSION="master"
PKG_SHA256=""
PKG_ARCH="any"
PKG_LICENSE="MIT"
PKG_SITE=""
PKG_URL=""
PKG_DEPENDS_TARGET="toolchain mali-rockchip libdrm"
PKG_SECTION="graphics"
PKG_LONGDESC="Wrapper that adds missing gbm functions not found in libmali"
PKG_TOOLCHAIN="manual"
PKG_BUILD_FLAGS="-gold -lto"

make_target() {
  echo "$CC $CFLAGS $LDFLAGS -I$SYSROOT_PREFIX/usr/include/libdrm -shared -fPIC gbm.c -o libgbm.so -lmali -ldrm"
  $CC $CFLAGS $LDFLAGS -I$SYSROOT_PREFIX/usr/include/libdrm -shared -fPIC gbm.c -o libgbm.so -lmali -ldrm
}

makeinstall_target() {
  cd $PKG_BUILD

  mkdir -p $SYSROOT_PREFIX/usr/include
    cp -fv gbm.h $SYSROOT_PREFIX/usr/include

  mkdir -p $SYSROOT_PREFIX/usr/lib/pkgconfig
    cp -fv $PKG_DIR/pkgconfig/*.pc $SYSROOT_PREFIX/usr/lib/pkgconfig
    cp -v --remove-destination libgbm.so $SYSROOT_PREFIX/usr/lib

  mkdir -p $INSTALL/usr/lib
    cp -v libgbm.so $INSTALL/usr/lib
}
