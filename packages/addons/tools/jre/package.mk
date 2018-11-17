# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2018-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="jre"
PKG_VERSION="8u192"
PKG_VERSION_BUILD="b12"
PKG_VERSION_REV="750e1c8617c5452694857ad95c3ee230"
PKG_SHA256="e8de2beec5e15631e4d87351eeb660e186d283cf359a52cec5c9c677db70e43b"
PKG_REV="100"
PKG_ARCH="arm"
PKG_LICENSE="nonfree"
PKG_SITE="http://www.oracle.com/"
PKG_URL="http://download.oracle.com/otn-pub/java/jdk/${PKG_VERSION}-${PKG_VERSION_BUILD}/${PKG_VERSION_REV}/jdk-${PKG_VERSION}-linux-arm32-vfp-hflt.tar.gz"
PKG_SECTION="tools"
PKG_SHORTDESC="Java SE Runtime Environment"
PKG_LONGDESC="The Java SE Runtime Environment contains the Java virtual machine, runtime class libraries, and Java application launcher that are necessary to run programs written in the Java programming language."
PKG_TOOLCHAIN="manual"

PKG_IS_ADDON="yes"
PKG_ADDON_NAME="Java Runtime Environment"
PKG_ADDON_TYPE="xbmc.python.script"

# hack to set some wget parameters
export VERBOSE="yes"
export WGET_OPT="--no-cookies --header=Cookie:oraclelicense=accept-securebackup-cookie"

addon() {
  mkdir -p $ADDON_BUILD/$PKG_ADDON_ID
    cp -a $PKG_DIR/profile.d $ADDON_BUILD/$PKG_ADDON_ID
    cp -a $PKG_BUILD/jre/* $ADDON_BUILD/$PKG_ADDON_ID
}
