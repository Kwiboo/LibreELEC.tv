# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2018-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="mali-utgard-rockchip"
PKG_VERSION="r8p1-00rel0"
PKG_SHA256="0036796165612eea75bee0e756fbd50c3137be257d4739b91aad0c159ae4016a"
PKG_ARCH="arm aarch64"
PKG_LICENSE="GPL"
PKG_SITE="https://developer.arm.com/products/software/mali-drivers/utgard-kernel"
PKG_URL="https://armkeil.blob.core.windows.net/developer/Files/downloads/mali-drivers/kernel/mali-utgard-gpu/DX910-SW-99002-$PKG_VERSION.tgz"
PKG_DEPENDS_TARGET="toolchain linux"
PKG_NEED_UNPACK="$LINUX_DEPENDS"
PKG_LONGDESC="mali-utgard-rockchip: Linux drivers for Mali Utgard GPUs found in Rockchip SoCs"
PKG_TOOLCHAIN="manual"
PKG_IS_KERNEL_PKG="yes"

make_target() {
  LDFLAGS="" make ARCH=$TARGET_KERNEL_ARCH CROSS_COMPILE=$TARGET_KERNEL_PREFIX KDIR=$(kernel_path) BUILD=release MALI_PLATFORM=rk USING_DT=1 USING_DEVFREQ=1 USING_UMP=0 USING_PROFILING=0 USING_DVFS=0 GIT_REV="" -C driver/src/devicedrv/mali
}

makeinstall_target() {
  mkdir -p $INSTALL/$(get_full_module_dir)/$PKG_NAME
    cp -v driver/src/devicedrv/mali/mali.ko $INSTALL/$(get_full_module_dir)/$PKG_NAME/
}
