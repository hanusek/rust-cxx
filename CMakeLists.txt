project(cxx_example)
cmake_minimum_required(VERSION 3.15)

set (CMAKE_CXX_STANDARD 17)

include_directories(${CMAKE_BINARY_DIR}/rust_part)
#include_directories(include)

add_subdirectory(rust_part)

add_executable(app main.cpp)

target_link_libraries(app rust_part)
