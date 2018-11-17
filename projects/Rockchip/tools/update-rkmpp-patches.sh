#!/bin/sh

SCRIPTPATH=$(dirname $0)
PKG_NAME=rkmpp
PKG_BASE=origin/release

if [ ! -d .git ]; then
  echo "ERROR: current path is not a git repository"
  exit 1
fi

rm -v 00*.patch
git format-patch $PKG_BASE --no-signature --no-numbered

mkdir -p $SCRIPTPATH/../../../packages/multimedia/$PKG_NAME/patches
rm -v $SCRIPTPATH/../../../packages/multimedia/$PKG_NAME/patches/${PKG_NAME}-00*.patch

for f in 00*.patch; do
  mv -fv $f $SCRIPTPATH/../../../packages/multimedia/$PKG_NAME/patches/${PKG_NAME}-$f
done
