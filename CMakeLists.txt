cmake_minimum_required(VERSION 3.9 FATAL_ERROR)
project(cpp-example)

include(CheckIncludeFileCXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED True)
set(CMAKE_CXX_EXTENSIONS False)

set(CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake" ${CMAKE_MODULE_PATH})

#include(rust_part_lib)

add_executable(app src/main.cpp)
target_link_libraries(app rust_part_lib -Wl,--allow-multiple-definition -ldl -lpthread)