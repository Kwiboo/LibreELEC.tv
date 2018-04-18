# OpenPHT-Embedded

OpenPHT-Embedded is a 'Just enough OS' Linux distribution for running [OpenPHT](https://github.com/RasPlex/OpenPHT) on popular mediacentre hardware.

**Notes**

* SSH login details are user: "root" password: "openpht" or "rasplex" depending on distribution.

**Build**

* `DISTRO=OpenPHT PROJECT=Generic ARCH=x86_64 make image`
* `DISTRO=RasPlex PROJECT=RPi DEVICE=RPi2 ARCH=arm make image`
* `DISTRO=OpenPHT PROJECT=Amlogic DEVICE=Odroid_C2 ARCH=arm make image`
* `DISTRO=OpenPHT PROJECT=Amlogic DEVICE=WeTek_Hub ARCH=arm make image`
* `DISTRO=OpenPHT PROJECT=Rockchip DEVICE=RK3328 ARCH=arm UBOOT_SYSTEM=rock64 make image`
* `DISTRO=OpenPHT PROJECT=Rockchip DEVICE=TinkerBoard ARCH=arm make image`
* Use `OPENPHT_REPO` and `OPENPHT_BRANCH` to change what repository and branch of OpenPHT to build

# LibreELEC

**Source code**

* https://github.com/LibreELEC/LibreELEC.tv

**License**

LibreELEC original code is released under [GPLv2](https://www.gnu.org/licenses/gpl-2.0.html).

**Copyright**

As LibreELEC includes code from many upstream projects it includes many copyright owners. LibreELEC makes NO claim of copyright on any upstream code. However all original LibreELEC authored code is copyright LibreELEC.tv. Patches to upstream code have the same license as the upstream project, unless specified otherwise. For a complete copyright list please checkout the source code to examine license headers. Unless expressly stated otherwise all code submitted to the LibreELEC project (in any form) is licensed under [GPLv2](https://www.gnu.org/licenses/gpl-2.0.html) and copyright is donated to LibreELEC.tv. This approach allows the project to stay manageable in the long term by giving us freedom to maintain the code as part of the whole without the management overhead of preserving contact with every submitter, e.g. GPLv3. You are absolutely free to retain copyright. To retain copyright simply add a copyright header to each submitted code page. If you submit code that is not your own work it is your responsibility to place a header stating the copyright.
