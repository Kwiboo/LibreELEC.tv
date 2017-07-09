################################################################################
#      This file is part of LibreELEC - https://libreelec.tv
#      Copyright (C) 2017 Team LibreELEC
#
#  LibreELEC is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 2 of the License, or
#  (at your option) any later version.
#
#  LibreELEC is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with LibreELEC.  If not, see <http://www.gnu.org/licenses/>.
################################################################################

PKG_NAME="arm-trusted-firmware"
PKG_VERSION="b762fc7"
PKG_ARCH="aarch64"
PKG_LICENSE="BSD"
PKG_SITE="https://github.com/ARM-software/arm-trusted-firmware"
PKG_URL="https://github.com/ARM-software/arm-trusted-firmware/archive/$PKG_VERSION.tar.gz"
PKG_SOURCE_DIR="arm-trusted-firmware-$PKG_VERSION*"
PKG_DEPENDS_TARGET="gcc-linaro-aarch64-elf:host"
PKG_SECTION="firmware"
PKG_SHORTDESC="arm-trusted-firmware: ARM Trusted Firmware provides a reference implementation of secure world software for ARMv8-A."
PKG_LONGDESC="ARM Trusted Firmware provides a reference implementation of secure world software for ARMv8-A, including a [Secure Monitor] TEE-SMC executing at Exception Level 3 (EL3)."

PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

pre_configure_target() {
  if [ -z "$UBOOT_SOC" ]; then
    echo "Please add UBOOT_SOC to your project or device options file, aborting."
    exit 1
  fi
}

make_target() {
  export PATH=$TOOLCHAIN/lib/gcc-linaro-aarch64-elf/bin/:$PATH
  CROSS_COMPILE=aarch64-elf- CFLAGS="" LDFLAGS="" make realclean
  CROSS_COMPILE=aarch64-elf- CFLAGS="" LDFLAGS="" make HOSTCC="$HOST_CC" BUILD_STRING="$PKG_VERSION" DEBUG=1 ERRATA_A53_835769=1 ERRATA_A53_843419=0 ERRATA_A53_855873=1 PLAT=$UBOOT_SOC bl31
}

makeinstall_target() {
  : # nothing
}
