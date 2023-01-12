# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2017-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="rkbin"
PKG_VERSION="215e6d6ac3622895006b04a84f081d0141c2c317"
PKG_SHA256="194949161a3dccff31b3aff92b99dc0387998cb801926080b79aa4e70d741ab9"
PKG_ARCH="arm aarch64"
PKG_LICENSE="nonfree"
PKG_SITE="https://github.com/rockchip-linux/rkbin"
PKG_URL="https://github.com/rockchip-linux/rkbin/archive/${PKG_VERSION}.tar.gz"
PKG_LONGDESC="rkbin: Rockchip Firmware and Tool Binaries"
PKG_TOOLCHAIN="manual"

make_target() {
  PKG_BOOT_INI="RKBOOT/${DEVICE}MINIALL.ini"
  if [ -f "${PKG_BOOT_INI}" ]; then
    PKG_FILE=$(sed -nr "/^\[LOADER_OPTION\]/ { :l /^FlashData[ ]*=/ { s/[^=]*=[ ]*//; p; q;}; n; b l;}" "${PKG_BOOT_INI}")
    if [ -f "${PKG_FILE}" ]; then
      cp -av "${PKG_FILE}" ddr.bin

      # Override sdram frequency
      if [ "${DEVICE}" = "RK3328" ]; then
        sed -s 's/\x4d\x1\x4d\x1\x4d\x1\x4d\x1\x4d\x1\x4d\x1/\x20\x3\x20\x3\x20\x3\x20\x3\x20\x3\x20\x3/g' -i ddr.bin
        sed -s 's/\x90\x1\x90\x1\x90\x1\x90\x1\x90\x1\x90\x1/\x20\x3\x20\x3\x20\x3\x20\x3\x20\x3\x20\x3/g' -i ddr.bin
      fi
    fi
  fi

  PKG_TRUST_INI="RKTRUST/${DEVICE}TRUST.ini"
  if [ -f "${PKG_TRUST_INI}" ]; then
    PKG_FILE=$(sed -nr "/^\[BL31_OPTION\]/ { :l /^PATH[ ]*=/ { s/[^=]*=[ ]*//; p; q;}; n; b l;}" "${PKG_TRUST_INI}")
    if [ -f "${PKG_FILE}" ]; then
      cp -av "${PKG_FILE}" bl31.elf
    fi
    PKG_FILE=$(sed -nr "/^\[BL32_OPTION\]/ { :l /^PATH[ ]*=/ { s/[^=]*=[ ]*//; p; q;}; n; b l;}" "${PKG_TRUST_INI}")
    if [ -f "${PKG_FILE}" ]; then
      cp -av "${PKG_FILE}" bl32.bin
    fi
  fi
}

makeinstall_target() {
  mkdir -p "${INSTALL}/.noinstall"
  for PKG_FILE in ddr.bin bl31.elf bl32.bin; do
    if [ -f "${PKG_FILE}" ]; then
      cp -av "${PKG_FILE}" "${INSTALL}/.noinstall"
    fi
  done
}
