# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2017-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="ffmpeg"
# Current branch is: release/4.0-kodi
PKG_VERSION="2c6b3f357331e203ad87214984661c40704aceb7"
PKG_SHA256="453c9c431b0fd5b51889d124864f485e96d72f6ee9a7636ebf5d5e4577bc2a04"
PKG_LICENSE="LGPLv2.1+"
PKG_SITE="https://ffmpeg.org"
PKG_URL="https://github.com/xbmc/FFmpeg/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain zlib bzip2 gnutls speex"
PKG_LONGDESC="FFmpeg is a complete, cross-platform solution to record, convert and stream audio and video."
PKG_BUILD_FLAGS="-gold"

# Dependencies
get_graphicdrivers

if [ "${V4L2_SUPPORT}" = "yes" ]; then
  PKG_DEPENDS_TARGET+=" libdrm"
  PKG_NEED_UNPACK+=" $(get_pkg_directory libdrm)"
  PKG_PATCH_DIRS+=" v4l2"
  PKG_FFMPEG_V4L2="--enable-v4l2_m2m --enable-libdrm"
else
  PKG_FFMPEG_V4L2="--disable-v4l2_m2m"
fi

if [ "${VAAPI_SUPPORT}" = "yes" ]; then
  PKG_DEPENDS_TARGET+=" libva"
  PKG_NEED_UNPACK+=" $(get_pkg_directory libva)"
  PKG_FFMPEG_VAAPI="--enable-vaapi"
else
  PKG_FFMPEG_VAAPI="--disable-vaapi"
fi

if [ "${VDPAU_SUPPORT}" = "yes" -a "${DISPLAYSERVER}" = "x11" ]; then
  PKG_DEPENDS_TARGET+=" libvdpau"
  PKG_NEED_UNPACK+=" $(get_pkg_directory libvdpau)"
  PKG_FFMPEG_VDPAU="--enable-vdpau"
else
  PKG_FFMPEG_VDPAU="--disable-vdpau"
fi

if [ "${PROJECT}" = "Allwinner" -o "${PROJECT}" = "Rockchip" ]; then
  PKG_DEPENDS_TARGET+=" libdrm systemd" # systemd is needed for libudev
  PKG_NEED_UNPACK+=" $(get_pkg_directory libdrm) $(get_pkg_directory systemd)"
  PKG_PATCH_DIRS+=" v4l2-request-api"
  PKG_FFMPEG_V4L2_REQUEST="--enable-v4l2-request --enable-libudev --enable-libdrm"
fi

if build_with_debug; then
  PKG_FFMPEG_DEBUG="--enable-debug --disable-stripping"
else
  PKG_FFMPEG_DEBUG="--disable-debug --enable-stripping"
fi

if [ "${KODIPLAYER_DRIVER}" = "bcm2835-driver" ]; then
  PKG_DEPENDS_TARGET+=" bcm2835-driver"
  PKG_NEED_UNPACK+=" $(get_pkg_directory bcm2835-driver)"
  if [ "${KODI_VENDOR}" = "raspberrypi" ]; then
    PKG_PATCH_DIRS+=" rpi-hevc"
  fi
fi

if target_has_feature neon; then
  PKG_FFMPEG_FPU="--enable-neon"
else
  PKG_FFMPEG_FPU="--disable-neon"
fi

if [ "${TARGET_ARCH}" = "x86_64" ]; then
  PKG_DEPENDS_TARGET+=" nasm:host"
fi

if target_has_feature "(neon|sse)"; then
  PKG_DEPENDS_TARGET+=" dav1d"
  PKG_NEED_UNPACK+=" $(get_pkg_directory dav1d)"
  PKG_FFMPEG_AV1="--enable-libdav1d"
fi

pre_configure_target() {
  cd ${PKG_BUILD}
  rm -rf .${TARGET_NAME}

  if [ "${KODIPLAYER_DRIVER}" = "bcm2835-driver" ]; then
    PKG_FFMPEG_LIBS="-lbcm_host -lvcos -lvchiq_arm -lmmal -lmmal_core -lmmal_util -lvcsm"
    if [ "${KODI_VENDOR}" = "raspberrypi" ]; then
      PKG_FFMPEG_RPI="--enable-rpi"
    fi
  fi
}

configure_target() {
  ./configure --prefix="/usr" \
              --cpu="${TARGET_CPU}" \
              --arch="${TARGET_ARCH}" \
              --enable-cross-compile \
              --cross-prefix="${TARGET_PREFIX}" \
              --sysroot="${SYSROOT_PREFIX}" \
              --sysinclude="${SYSROOT_PREFIX}/usr/include" \
              --target-os="linux" \
              --nm="${NM}" \
              --ar="${AR}" \
              --as="${CC}" \
              --cc="${CC}" \
              --ld="${CC}" \
              --host-cc="${HOST_CC}" \
              --host-cflags="${HOST_CFLAGS}" \
              --host-ldflags="${HOST_LDFLAGS}" \
              --extra-cflags="${CFLAGS}" \
              --extra-ldflags="${LDFLAGS}" \
              --extra-libs="${PKG_FFMPEG_LIBS}" \
              --disable-static \
              --enable-shared \
              --enable-gpl \
              --disable-version3 \
              --enable-logging \
              --disable-doc \
              ${PKG_FFMPEG_DEBUG} \
              --enable-pic \
              --pkg-config="${TOOLCHAIN}/bin/pkg-config" \
              --enable-optimizations \
              --disable-extra-warnings \
              --enable-avdevice \
              --enable-avcodec \
              --enable-avformat \
              --enable-swscale \
              --enable-postproc \
              --enable-avfilter \
              --disable-devices \
              --enable-pthreads \
              --enable-network \
              --enable-gnutls --disable-openssl \
              --disable-gray \
              --enable-swscale-alpha \
              --disable-small \
              --enable-dct \
              --enable-fft \
              --enable-mdct \
              --enable-rdft \
              --disable-crystalhd \
              ${PKG_FFMPEG_V4L2} \
              ${PKG_FFMPEG_VAAPI} \
              ${PKG_FFMPEG_VDPAU} \
              ${PKG_FFMPEG_RPI} \
              ${PKG_FFMPEG_V4L2_REQUEST} \
              --enable-runtime-cpudetect \
              --disable-hardcoded-tables \
              --disable-encoders \
              --enable-encoder=ac3 \
              --enable-encoder=aac \
              --enable-encoder=wmav2 \
              --enable-encoder=mjpeg \
              --enable-encoder=png \
              --enable-encoder=wrapped_avframe \
              --enable-encoder=pcm_s16le \
              --enable-encoder=rawvideo \
              --enable-hwaccels \
              --disable-muxers \
              --enable-muxer=spdif \
              --enable-muxer=adts \
              --enable-muxer=asf \
              --enable-muxer=ipod \
              --enable-muxer=mpegts \
              --enable-muxer=null \
              --enable-muxer=rawvideo \
              --enable-demuxers \
              --enable-parsers \
              --enable-bsfs \
              --enable-protocol=http \
              --disable-indevs \
              --disable-outdevs \
              --enable-filters \
              --disable-avisynth \
              --enable-bzlib \
              --disable-lzma \
              --disable-alsa \
              --disable-frei0r \
              --disable-libopencore-amrnb \
              --disable-libopencore-amrwb \
              --disable-libopencv \
              --disable-libdc1394 \
              --disable-libfreetype \
              --disable-libgsm \
              --disable-libmp3lame \
              --disable-libopenjpeg \
              --disable-librtmp \
              ${PKG_FFMPEG_AV1} \
              --enable-libspeex \
              --disable-libtheora \
              --disable-libvo-amrwbenc \
              --disable-libvorbis \
              --disable-libvpx \
              --disable-libx264 \
              --disable-libxavs \
              --disable-libxvid \
              --enable-zlib \
              --enable-asm \
              --disable-altivec \
              ${PKG_FFMPEG_FPU} \
              --disable-symver
}

post_makeinstall_target() {
  rm -rf ${INSTALL}/usr/share/ffmpeg/examples
}
