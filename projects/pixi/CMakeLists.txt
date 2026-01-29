cmake_minimum_required(VERSION 3.20)
project(pm_pixi LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_LIST_DIR}/../../cmake")

include(FetchContent)

find_package(fmt CONFIG REQUIRED)
find_package(CGAL CONFIG REQUIRED)
find_package(OpenMP QUIET)

find_package(manifold CONFIG QUIET)
if (NOT manifold_FOUND)
  message(STATUS "manifold not found; fetching from source")
  set(MANIFOLD_BUILD_TESTS OFF CACHE BOOL "Disable manifold tests" FORCE)
  set(MANIFOLD_BUILD_DOCS OFF CACHE BOOL "Disable manifold docs" FORCE)
  FetchContent_Declare(
    manifold
    GIT_REPOSITORY https://github.com/elalish/manifold.git
    GIT_TAG master
  )
  FetchContent_MakeAvailable(manifold)
endif()
if (TARGET manifold::manifold)
  set(MANIFOLD_TARGET manifold::manifold)
elseif (TARGET manifold)
  set(MANIFOLD_TARGET manifold)
else()
  message(FATAL_ERROR "manifold target missing")
endif()

find_package(Geogram CONFIG QUIET)
if (NOT Geogram_FOUND)
  find_package(Geogram QUIET)
endif()
if (NOT Geogram_FOUND)
  message(STATUS "Geogram not found; fetching from source")
  if (NOT VORPALINE_PLATFORM)
    if (UNIX AND NOT APPLE)
      set(VORPALINE_PLATFORM "Linux64-gcc" CACHE STRING "Geogram platform")
    elseif (APPLE)
      set(VORPALINE_PLATFORM "Darwin-clang" CACHE STRING "Geogram platform")
    endif()
  endif()
  if (NOT DEFINED GEOGRAM_WITH_GRAPHICS)
    set(GEOGRAM_WITH_GRAPHICS OFF CACHE BOOL "Disable Geogram graphics components")
  endif()
  FetchContent_Declare(
    geogram
    GIT_REPOSITORY https://github.com/BrunoLevy/geogram.git
    GIT_TAG main
  )
  FetchContent_MakeAvailable(geogram)
endif()
if (TARGET Geogram::geogram)
  set(GEOGRAM_TARGET Geogram::geogram)
elseif (TARGET geogram)
  set(GEOGRAM_TARGET geogram)
else()
  message(FATAL_ERROR "Geogram target missing")
endif()

add_executable(app src/main.cpp)
target_link_libraries(app PRIVATE fmt::fmt CGAL::CGAL ${MANIFOLD_TARGET} ${GEOGRAM_TARGET})
if (OpenMP_CXX_FOUND)
  target_link_libraries(app PRIVATE OpenMP::OpenMP_CXX)
endif()
