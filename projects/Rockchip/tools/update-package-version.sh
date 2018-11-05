#!/bin/bash

SCRIPTPATH=$(dirname $0)

function get_pkg_sha256 {
  PKG_REPO=$1
  PKG_VERSION=$2

  tmpfile=$(mktemp)

  url="${PKG_REPO::-4}/archive/$PKG_VERSION.tar.gz"
  wget_cmd="wget -q --timeout=30 --tries=3 --no-check-certificate -c -O${tmpfile}"

  if ${wget_cmd} "${url}"; then
    [ -s ${tmpfile} ] && sha256sum ${tmpfile} | cut -d" " -f1
  fi

  rm -f ${tmpfile}
}

function update_pkg_version {
  PKG_NAME=$1
  PKG_REPO=$2
  PKG_BRANCH=$3
  PKG_DL_REPO=${4:-$2}

  PKG_PATH=$(find $SCRIPTPATH/../packages/ -name $PKG_NAME -type d -print)/package.mk
  if [ ! -f $PKG_PATH ]; then
    PKG_PATH=$(find $SCRIPTPATH/../../../packages/ -name $PKG_NAME -type d -print)/package.mk
  fi

  if [ ! -f $PKG_PATH ]; then
    echo "ERROR: PKG_PATH does not exists"
    exit 1
  fi

  echo "$PKG_NAME ($PKG_BRANCH @ $PKG_REPO)"

  if [ "$PKG_NAME" = "linux" ]; then
    eval $(grep "^  rockchip-4.4)" $PKG_PATH -A1 | grep PKG_VERSION)
    eval $(grep "^  rockchip-4.4)" $PKG_PATH -A2 | grep PKG_SHA256)
  elif [ "$PKG_NAME" = "u-boot" ]; then
    eval $(grep "^  Rockchip)" $PKG_PATH -A1 | grep PKG_VERSION)
    eval $(grep "^  Rockchip)" $PKG_PATH -A2 | grep PKG_SHA256)
  elif [ "$PKG_NAME" = "kodi" ]; then
    eval $(grep "^  rockchip)" $PKG_PATH -A1 | grep PKG_VERSION)
    eval $(grep "^  rockchip)" $PKG_PATH -A2 | grep PKG_SHA256)
  else
    eval $(grep "^PKG_VERSION" $PKG_PATH)
    eval $(grep "^PKG_SHA256" $PKG_PATH)
  fi

  if [ -z "$PKG_VERSION" ]; then
    echo "ERROR: PKG_VERSION is empty"
    exit 1
  fi

  echo " PKG_VERSION=$PKG_VERSION"
  echo " PKG_SHA256=$PKG_SHA256"

  GIT_REV=$(git ls-remote --heads $PKG_REPO $PKG_BRANCH | cut -c1-40)

  if [ -z "$GIT_REV" ]; then
    echo "ERROR: GIT_REV is empty"
    exit 1
  fi

  echo " GIT_REV=$GIT_REV"

  if [ "$PKG_VERSION" != "$GIT_REV" ]; then
    echo "Updating package.mk"
    sed -i "s/PKG_VERSION=\"$PKG_VERSION\"/PKG_VERSION=\"$GIT_REV\"/" $PKG_PATH
    sed -i "s/PKG_SHA256=\"$PKG_SHA256\"/PKG_SHA256=\"$(get_pkg_sha256 $PKG_DL_REPO $GIT_REV)\"/" $PKG_PATH
  fi

  echo
}

if [ "$1" = "kodi" ]; then
  update_pkg_version kodi https://github.com/xbmc/xbmc.git master https://github.com/kwiboo/xbmc.git
elif [ "$1" = "ffmpeg" ]; then
  update_pkg_version ffmpeg https://github.com/xbmc/FFmpeg.git release/4.0-kodi
elif [ "$1" = "mali" ]; then
  update_pkg_version mali-rockchip https://github.com/rockchip-linux/libmali.git rockchip
elif [ "$1" = "rkmpp" ]; then
  update_pkg_version rkmpp https://github.com/rockchip-linux/mpp.git release
elif [ "$1" = "u-boot" ]; then
  update_pkg_version u-boot https://github.com/Kwiboo/u-boot-rockchip.git release https://github.com/rockchip-linux/u-boot.git
else
  update_pkg_version linux https://github.com/Kwiboo/linux-rockchip.git release-4.4 https://github.com/rockchip-linux/kernel.git
  update_pkg_version rkbin https://github.com/Kwiboo/rkbin.git libreelec-cleanup
fi
