# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2017-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="rkbin"
PKG_VERSION="54401467b858de46201e9f944bc7302814339782"
PKG_SHA256="051731b9c3eabf408d0e0a9b64d3fa4529466d6e1de9b1aebbb37de1b18da820"
PKG_ARCH="arm aarch64"
PKG_LICENSE="nonfree"
PKG_SITE="https://github.com/rockchip-linux/rkbin"
PKG_URL="https://github.com/rockchip-linux/rkbin/archive/$PKG_VERSION.tar.gz"
PKG_LONGDESC="rkbin: Rockchip Firmware and Tool Binaries"
PKG_TOOLCHAIN="manual"
PKG_STAMP="$UBOOT_SYSTEM"

[ -n "$KERNEL_TOOLCHAIN" ] && PKG_DEPENDS_TARGET+=" gcc-arm-$KERNEL_TOOLCHAIN:host"

make_target() {
  if [ "$DEVICE" = "RK3288" ]; then
    # Use vendor ddr init and miniloader blob
    #cp -av bin/rk32/rk3288_ddr_400MHz_v1.08.bin ddr.bin
    #cp -av bin/rk32/rk3288_miniloader_v2.58.bin miniloader.bin

    # Make tee.bin avilable for u-boot fit-image
    cp -av bin/rk32/rk3288_tee_ta_v1.45.bin tee.bin

    # Build trust.img for use with miniloader blob
    #tools/loaderimage --pack --trustos tee.bin trust.img 0x8400000
  elif [ "$DEVICE" = "RK3328" ]; then
    # Use vendor ddr init and miniloader blob
    #cp -av bin/rk32/rk3288_ddr_400MHz_v1.08.bin ddr.bin
    #cp -av bin/rk32/rk3288_miniloader_v2.58.bin miniloader.bin

    # Make bl31 and bl32 avilable for u-boot fit-image
    cp -av bin/rk33/rk322xh_bl31_v1.43.elf bl31.elf
    #cp -av bin/rk33/rk322xh_bl32_v1.54.bin bl32.bin

    # Build trust.img for use with miniloader blob
    #tools/trust_merger --verbose RKTRUST/RK3328TRUST.ini
  elif [ "$DEVICE" = "RK3399" ]; then
    # Make bl31 and bl32 avilable for u-boot fit-image
    cp -av bin/rk33/rk3399_bl31_v1.33.elf bl31.elf
    #cp -av bin/rk33/rk3399_bl32_v1.24.bin bl32.bin

    # Build trust.img for use with miniloader blob
    #tools/trust_merger --verbose RKTRUST/RK3399TRUST.ini
  fi

  if [ -f bl32.bin ]; then
    ${TARGET_KERNEL_PREFIX}objcopy -B aarch64 -I binary -O elf64-littleaarch64 bl32.bin bl32.o
    ${TARGET_KERNEL_PREFIX}ld bl32.o -T tee.ld -o tee.elf
  fi
}

makeinstall_target() {
  mkdir -p $INSTALL/.noinstall
  for PKG_FILE in bl31.elf tee.elf tee.bin ddr.bin miniloader.bin; do
    if [ -f $PKG_FILE ]; then
      cp -av $PKG_FILE $INSTALL/.noinstall
    fi
  done

  if [ -f trust.img ]; then
    mkdir -p $INSTALL/usr/share/bootloader
    cp -av trust.img $INSTALL/usr/share/bootloader
  fi
}
