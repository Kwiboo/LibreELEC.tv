# FFmpeg patches

* Kodi patches\
  `4.3-Matrix-Alpha1` tag from https://github.com/xbmc/FFmpeg
* Misc LibreELEC patches\
  `4.3-libreelec-misc` branch from https://github.com/LibreELEC/FFmpeg
* v4l2 stateful DRMPRIME patches from [@lrusak](https://github.com/lrusak)\
  `v4l2-drmprime-v5` branch from https://github.com/lrusak/FFmpeg
* v4l2 stateless / request api patches from [@Kwiboo](https://github.com/Kwiboo)\
  `v4l2-request-hwaccel-4.3` branch from https://github.com/Kwiboo/FFmpeg
* RPi patches from [@jc-kynesim](https://github.com/jc-kynesim) (based on request api patches)\
  `test/4.3/kodi_main` branch from https://github.com/jc-kynesim/rpi-ffmpeg

## Update patches

```
FFMPEG_REF=refs/tags/n4.3
KODI_REF=refs/tags/4.3-Matrix-Alpha1
MISC_REF=refs/heads/4.3-libreelec-misc
V4L2_STATEFUL_REF=refs/heads/v4l2-drmprime-v5
V4L2_STATELESS_REF=refs/heads/v4l2-request-hwaccel-4.3
RPI_REF=refs/heads/test/4.3/kodi_main

git fetch https://github.com/FFmpeg/FFmpeg.git $FFMPEG_REF
FFMPEG_REV=$(git rev-parse FETCH_HEAD)
git fetch https://github.com/xbmc/FFmpeg.git $KODI_REF
KODI_REV=$(git rev-parse FETCH_HEAD)
git fetch https://github.com/LibreELEC/FFmpeg.git $MISC_REF
MISC_REV=$(git rev-parse FETCH_HEAD)
git fetch https://github.com/lrusak/FFmpeg.git $V4L2_STATEFUL_REF
V4L2_STATEFUL_REV=$(git rev-parse FETCH_HEAD)
git fetch https://github.com/Kwiboo/FFmpeg.git $V4L2_STATELESS_REF
V4L2_STATELESS_REV=$(git rev-parse FETCH_HEAD)
git fetch https://github.com/jc-kynesim/rpi-ffmpeg.git $RPI_REF
RPI_REV=$(git rev-parse FETCH_HEAD)

git format-patch $FFMPEG_REV..$KODI_REV --histogram --no-signature --stdout > ffmpeg-0001-kodi.patch
git format-patch $FFMPEG_REV..$MISC_REV --histogram --no-signature --stdout > ffmpeg-0002-libreelec-misc.patch
git format-patch $FFMPEG_REV..$V4L2_STATEFUL_REV --histogram --no-signature --stdout > ffmpeg-0003-v4l2-stateful.patch
git format-patch $KODI_REV..$V4L2_STATELESS_REV --histogram --no-signature --stdout > ffmpeg-0004-v4l2-stateless.patch
git diff $V4L2_STATELESS_REV..$RPI_REV --histogram > ffmpeg-0005-rpi.patch
```
