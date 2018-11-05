#!/bin/sh

SCRIPTPATH=$(dirname $0)
PKG_NAME=u-boot
eval $(grep "^  Rockchip)" $SCRIPTPATH/../../../packages/tools/$PKG_NAME/package.mk -A2 | grep PKG_VERSION)
PKG_BASE=$PKG_VERSION

if [ ! -d .git ]; then
  echo "ERROR: current path is not a git repository"
  exit 1
fi

rm -v 00*.patch
git format-patch $PKG_BASE --no-signature --no-numbered

mkdir -p $SCRIPTPATH/../../../packages/tools/$PKG_NAME/patches/rockchip
rm -v $SCRIPTPATH/../../../packages/tools/$PKG_NAME/patches/rockchip/${PKG_NAME}-00*.patch

for f in 00*.patch; do
  mv -fv $f $SCRIPTPATH/../../../packages/tools/$PKG_NAME/patches/rockchip/${PKG_NAME}-$f
done
