
/* Enable 64-bit mmap also when compiling for 32 bit */
#define _FILE_OFFSET_BITS 64

#include <stddef.h>
#include <string.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <sys/mman.h>
#include <xf86drm.h>
#include "gbm.h"

void *
gbm_bo_map(struct gbm_bo *bo,
           uint32_t x, uint32_t y, uint32_t width, uint32_t height,
           uint32_t flags, uint32_t *stride, void **map_data)
{
    struct drm_mode_map_dumb mreq = {};
    struct gbm_device *device = gbm_bo_get_device(bo);
    int fd = gbm_device_get_fd(device);

    mreq.handle = gbm_bo_get_handle(bo).u32;
    int ret = drmIoctl(fd, DRM_IOCTL_MODE_MAP_DUMB, &mreq);
    if (ret)
        return MAP_FAILED;

    void *map = mmap(NULL, gbm_bo_get_stride(bo) * gbm_bo_get_height(bo), PROT_READ | PROT_WRITE, MAP_SHARED, fd, mreq.offset);
    if (map != MAP_FAILED) {
        *map_data = map;
        *stride = gbm_bo_get_stride(bo);
    }

    return map;
}

void
gbm_bo_unmap(struct gbm_bo *bo, void *map_data)
{
    if (map_data)
        munmap(map_data, gbm_bo_get_stride(bo) * gbm_bo_get_height(bo));
}

int
gbm_device_get_format_modifier_plane_count(struct gbm_device *gbm,
                                           uint32_t format,
                                           uint64_t modifier)
{
    return 1;
}

struct gbm_bo *
gbm_bo_create_with_modifiers(struct gbm_device *gbm,
                             uint32_t width, uint32_t height,
                             uint32_t format,
                             const uint64_t *modifiers,
                             const unsigned int count)
{
    return gbm_bo_create(gbm, width, height, format, GBM_BO_USE_LINEAR);
}

uint32_t
gbm_bo_get_stride_for_plane(struct gbm_bo *bo, int plane)
{
    return gbm_bo_get_stride(bo);
}

uint32_t
gbm_bo_get_offset(struct gbm_bo *bo, int plane)
{
    return 0;
}

uint64_t
gbm_bo_get_modifier(struct gbm_bo *bo)
{
    return 0;
}

int
gbm_bo_get_plane_count(struct gbm_bo *bo)
{
    return 1;
}

union gbm_bo_handle
gbm_bo_get_handle_for_plane(struct gbm_bo *bo, int plane)
{
    return gbm_bo_get_handle(bo);
}

struct gbm_surface *
gbm_surface_create_with_modifiers(struct gbm_device *gbm,
                                  uint32_t width, uint32_t height,
                                  uint32_t format,
                                  const uint64_t *modifiers,
                                  const unsigned int count)

{
    return gbm_surface_create(gbm, width, height, format, GBM_BO_USE_LINEAR);
}

uint32_t
gbm_bo_get_bpp(struct gbm_bo *bo)
{
   switch (gbm_bo_get_format(bo)) {
      default:
         return 0;
      case GBM_FORMAT_C8:
      case GBM_FORMAT_R8:
      case GBM_FORMAT_RGB332:
      case GBM_FORMAT_BGR233:
         return 8;
      case GBM_FORMAT_GR88:
      case GBM_FORMAT_XRGB4444:
      case GBM_FORMAT_XBGR4444:
      case GBM_FORMAT_RGBX4444:
      case GBM_FORMAT_BGRX4444:
      case GBM_FORMAT_ARGB4444:
      case GBM_FORMAT_ABGR4444:
      case GBM_FORMAT_RGBA4444:
      case GBM_FORMAT_BGRA4444:
      case GBM_FORMAT_XRGB1555:
      case GBM_FORMAT_XBGR1555:
      case GBM_FORMAT_RGBX5551:
      case GBM_FORMAT_BGRX5551:
      case GBM_FORMAT_ARGB1555:
      case GBM_FORMAT_ABGR1555:
      case GBM_FORMAT_RGBA5551:
      case GBM_FORMAT_BGRA5551:
      case GBM_FORMAT_RGB565:
      case GBM_FORMAT_BGR565:
         return 16;
      case GBM_FORMAT_RGB888:
      case GBM_FORMAT_BGR888:
         return 24;
      case GBM_FORMAT_XRGB8888:
      case GBM_FORMAT_XBGR8888:
      case GBM_FORMAT_RGBX8888:
      case GBM_FORMAT_BGRX8888:
      case GBM_FORMAT_ARGB8888:
      case GBM_FORMAT_ABGR8888:
      case GBM_FORMAT_RGBA8888:
      case GBM_FORMAT_BGRA8888:
      case GBM_FORMAT_XRGB2101010:
      case GBM_FORMAT_XBGR2101010:
      case GBM_FORMAT_RGBX1010102:
      case GBM_FORMAT_BGRX1010102:
      case GBM_FORMAT_ARGB2101010:
      case GBM_FORMAT_ABGR2101010:
      case GBM_FORMAT_RGBA1010102:
      case GBM_FORMAT_BGRA1010102:
         return 32;
   }
}
