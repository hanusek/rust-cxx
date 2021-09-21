#!/bin/bash

rm -rf ./build

cxxbridge ./src/lib.rs --header > ./src/lib.rs.h
cargo build
mkdir build && cd build
cmake ..
make