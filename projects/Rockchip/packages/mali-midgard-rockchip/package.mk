# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2018-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="mali-midgard-rockchip"
PKG_VERSION="r28p0-01rel0"
PKG_SHA256="9e427eb99ce5384115959d91efd5e2d90e1f876e323c03817db350d936d372b0"
PKG_ARCH="arm aarch64"
PKG_LICENSE="GPL"
PKG_SITE="https://developer.arm.com/products/software/mali-drivers/midgard-kernel"
PKG_URL="https://armkeil.blob.core.windows.net/developer/Files/downloads/mali-drivers/kernel/mali-midgard-gpu/TX011-SW-99002-$PKG_VERSION.tgz"
PKG_DEPENDS_TARGET="toolchain linux"
PKG_NEED_UNPACK="$LINUX_DEPENDS"
PKG_LONGDESC="mali-midgard-rockchip: Linux drivers for Mali Midgard GPUs found in Rockchip SoCs"
PKG_TOOLCHAIN="manual"
PKG_IS_KERNEL_PKG="yes"

make_target() {
  kernel_make -C $(kernel_path) M=$PKG_BUILD/driver/product/kernel/drivers/gpu/arm/midgard \
    CONFIG_MALI_MIDGARD=m CONFIG_MALI_GATOR_SUPPORT=n CONFIG_MALI_PLATFORM_NAME=rk \
    modules
#  kernel_make -C $(kernel_path) M=$PKG_BUILD/driver/product/kernel/drivers/gpu/arm/midgard \
#    CFLAGS_MODULE="-DCONFIG_MALI_DEVFREQ" \
#    CONFIG_MALI_MIDGARD=m CONFIG_MALI_GATOR_SUPPORT=n CONFIG_MALI_DEVFREQ=y CONFIG_MALI_PLATFORM_NAME=rk \
#    modules
}

makeinstall_target() {
 kernel_make -C $(kernel_path) M=$PKG_BUILD/driver/product/kernel/drivers/gpu/arm/midgard \
    INSTALL_MOD_PATH=$INSTALL/$(get_kernel_overlay_dir) INSTALL_MOD_STRIP=1 DEPMOD=: \
    modules_install
}
