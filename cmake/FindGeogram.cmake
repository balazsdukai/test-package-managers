include(FindPackageHandleStandardArgs)

find_path(Geogram_INCLUDE_DIR
  NAMES geogram/basic/common.h
)

find_library(Geogram_LIBRARY
  NAMES geogram
)

find_library(Geogram_GFX_LIBRARY
  NAMES geogram_gfx
)

find_package_handle_standard_args(Geogram
  REQUIRED_VARS Geogram_INCLUDE_DIR Geogram_LIBRARY
)

if (Geogram_FOUND)
  if (NOT TARGET Geogram::geogram)
    add_library(Geogram::geogram UNKNOWN IMPORTED)
    set_target_properties(Geogram::geogram PROPERTIES
      IMPORTED_LOCATION "${Geogram_LIBRARY}"
      INTERFACE_INCLUDE_DIRECTORIES "${Geogram_INCLUDE_DIR}"
    )
  endif()

  if (Geogram_GFX_LIBRARY AND NOT TARGET Geogram::geogram_gfx)
    add_library(Geogram::geogram_gfx UNKNOWN IMPORTED)
    set_target_properties(Geogram::geogram_gfx PROPERTIES
      IMPORTED_LOCATION "${Geogram_GFX_LIBRARY}"
      INTERFACE_INCLUDE_DIRECTORIES "${Geogram_INCLUDE_DIR}"
    )
  endif()
endif()
