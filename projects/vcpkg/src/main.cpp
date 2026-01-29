#include <CGAL/version.h>
#include <fmt/core.h>
#include <geogram/basic/command_line.h>
#include <manifold/manifold.h>

int main() {
  fmt::print("Hello from vcpkg\n");
  fmt::print("CGAL version: {}\n", CGAL_VERSION_STR);

  manifold::Manifold cube = manifold::Manifold::Cube(manifold::vec3(1.0f));
  fmt::print("Manifold cube volume: {}\n", cube.Volume());

  GEO::CmdLine::initialize();
  fmt::print("Geogram initialized\n");
  GEO::CmdLine::terminate();
  return 0;
}
