# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2018-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="mpv-rockchip"
PKG_VERSION="v0.29.1"
PKG_SHA256="f9f9d461d1990f9728660b4ccb0e8cb5dce29ccaa6af567bec481b79291ca623"
PKG_LICENSE="GPL"
PKG_SITE="https://mpv.io/"
PKG_URL="https://github.com/mpv-player/mpv/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain ffmpeg libass libdrm alsa rkmpp $OPENGLES"
PKG_SHORTDESC="mpv: Video player based on MPlayer/mplayer2"
PKG_LONGDESC="mpv: mpv is a media player based on MPlayer and mplayer2. It supports a wide variety of video file formats, audio and video codecs, and subtitle types."
PKG_TOOLCHAIN="manual"

PKG_CONFIGURE_OPTS_TARGET="--disable-libsmbclient --disable-apple-remote --prefix=/usr --enable-drmprime --enable-drm --enable-gbm --enable-egl-drm"

if [ "$PULSEAUDIO_SUPPORT" = yes ]; then
  PKG_DEPENDS_TARGET+=" pulseaudio"
  PKG_CONFIGURE_OPTS_TARGET+=" --enable-pulse"
else
  PKG_CONFIGURE_OPTS_TARGET+=" --disable-pulse"
fi

if [ "$KODI_BLURAY_SUPPORT" = yes ]; then
  PKG_DEPENDS_TARGET+=" libbluray"
  PKG_CONFIGURE_OPTS_TARGET+=" --enable-libbluray"
else
  PKG_CONFIGURE_OPTS_TARGET+=" --disable-libbluray"
fi

configure_target() {
  cd $PKG_BUILD
    ./bootstrap.py
    ./waf configure $PKG_CONFIGURE_OPTS_TARGET
}

make_target() {
  cd $PKG_BUILD
    ./waf build
}

makeinstall_target() {
  cd $PKG_BUILD
    ./waf install --destdir=$INSTALL
}
