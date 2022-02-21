project(cxx_example)
cmake_minimum_required(VERSION 3.15)

set(CMAKE_CXX_STANDARD 17)

if(CMAKE_CROSSCOMPILING)
  set(ARCH "ARM")
else()
  if(CMAKE_FORCE_32_BIT)
    set(ARCH "X86")
  else()
    set(ARCH "X86_64")
  endif()
endif()

set(CXX_RUST_LIB_NAME "rust_part")
set(CXX_RUST_LIB_DIR "${CMAKE_CURRENT_SOURCE_DIR}/${CXX_RUST_LIB_NAME}")

include(add_rust_library.cmake)

add_rust_library(
  TARGET ${CXX_RUST_LIB_NAME} 
  PATH ${CXX_RUST_LIB_DIR}
  ARCH ${ARCH}
)

add_executable(app main.cpp)
target_link_libraries(app rust_part)
