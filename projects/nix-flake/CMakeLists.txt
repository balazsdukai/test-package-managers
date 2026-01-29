cmake_minimum_required(VERSION 3.20)
project(pm_nix_flake LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

find_package(fmt CONFIG REQUIRED)

add_executable(app src/main.cpp)
target_link_libraries(app PRIVATE fmt::fmt)
