#!/bin/bash

cargo build
mkdir build && cd build
cmake ..
make