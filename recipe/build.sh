#!/bin/bash

set -ex

mkdir build-shared
cd build-shared
cmake ${CMAKE_ARGS} -GNinja \
  -DCMAKE_PREFIX_PATH=$PREFIX \
  -DCMAKE_INSTALL_PREFIX="${PREFIX}" \
  -DCMAKE_INSTALL_LIBDIR=lib \
  -DENABLE_TESTING=OFF \
  -DCMAKE_BUILD_TYPE=Release \
  -DBUILD_SHARED_LIBS=ON \
  ..
ninja install
cd ..

mkdir build-static
cd build-static
cmake ${CMAKE_ARGS} -GNinja \
  -DCMAKE_PREFIX_PATH=$PREFIX \
  -DCMAKE_INSTALL_PREFIX="${PREFIX}" \
  -DCMAKE_INSTALL_LIBDIR=lib \
  -DENABLE_TESTING=OFF \
  -DCMAKE_BUILD_TYPE=Release \
  -DBUILD_SHARED_LIBS=OFF \
  ..
ninja install
