# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Lukas Rusak (lrusak@libreelec.tv)
# Copyright (C) 2016-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="hyperion.ng"
PKG_VERSION="1aba51e85c4c3f7cac438aa7bf6a845ef536b42e"
PKG_SHA256="882dc3fa46a2edf1fd066649239dd27a8901077071a2418b5fd4d36eadf50fb0"
PKG_VERSION_DATE="2020-01-15"
PKG_REV="100"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/hyperion-project/hyperion.ng"
PKG_URL="https://github.com/hyperion-project/hyperion.ng/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain Python3 libusb qtbase qtserialport protobuf rpi_ws281x avahi flatbuffers"
PKG_DEPENDS_UNPACK="rpi_ws281x"
PKG_SECTION="service"
PKG_SHORTDESC="Hyperion.NG: an AmbiLight controller"
PKG_LONGDESC="Hyperion.NG($PKG_VERSION_DATE) is an modern opensource AmbiLight implementation."
PKG_BUILD_FLAGS="-sysroot"

PKG_IS_ADDON="yes"
PKG_ADDON_NAME="Hyperion.NG"
PKG_ADDON_TYPE="xbmc.service"

PKG_DISPMANX_SUPPORT="-DENABLE_DISPMANX=OFF"
PKG_FB_SUPPORT="-DENABLE_FB=ON"
PKG_X11_SUPPORT="-DENABLE_X11=OFF"

if [ "$KODIPLAYER_DRIVER" = "bcm2835-driver" ]; then
  PKG_DEPENDS_TARGET+=" bcm2835-driver"
  PKG_DISPMANX_SUPPORT="-DENABLE_DISPMANX=ON"
  PKG_FB_SUPPORT="-DENABLE_FB=OFF"
elif [ "$DISPLAYSERVER" = "x11" ]; then
  PKG_DEPENDS_TARGET+=" xorg-server xrandr"
  PKG_X11_SUPPORT="-DENABLE_X11=ON"
fi

PKG_CMAKE_OPTS_TARGET="-DCMAKE_NO_SYSTEM_FROM_IMPORTED=ON \
                       -DENABLE_AMLOGIC=OFF \
                       $PKG_DISPMANX_SUPPORT \
                       $PKG_FB_SUPPORT \
                       -DENABLE_OSX=OFF \
                       -DUSE_SYSTEM_PROTO_LIBS=ON \
                       -DUSE_SYSTEM_FLATBUFFERS_LIBS=ON \
                       -DENABLE_SPIDEV=ON \
                       -DENABLE_TINKERFORGE=OFF \
                       -DENABLE_V4L2=ON \
                       -DENABLE_WS281XPWM=ON \
                       $PKG_X11_SUPPORT \
                       -DENABLE_TESTS=OFF \
                       -Wno-dev \
                       -DQT_BIN_PATH=$TOOLCHAIN/bin"

pre_build_target() {
  cp -a $(get_build_dir rpi_ws281x)/* $PKG_BUILD/dependencies/external/rpi_ws281x
}

pre_configure_target() {
  echo "set(HYPERION_BUILD_ID \"$PKG_VERSION\")" > ../cmake/FindGitVersion.cmake
}

addon() {
  mkdir -p $ADDON_BUILD/$PKG_ADDON_ID/bin
    cp $PKG_INSTALL/usr/bin/* $ADDON_BUILD/$PKG_ADDON_ID/bin

  cp -PR $PKG_INSTALL/usr/share/hyperion/effects $ADDON_BUILD/$PKG_ADDON_ID
}
