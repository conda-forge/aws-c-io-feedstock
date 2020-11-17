mkdir build-shared
cd build-shared

cmake -G "Ninja" ^
      -DCMAKE_PREFIX_PATH=%LIBRARY_PREFIX% ^
      -DCMAKE_INSTALL_PREFIX="%LIBRARY_PREFIX%" ^
      -DCMAKE_INSTALL_LIBDIR=lib ^
      -DCMAKE_BUILD_TYPE=Release ^
      -DBUILD_SHARED_LIBS=ON ^
      ..
if errorlevel 1 exit 1

ninja install
if errorlevel 1 exit 1
cd ..

mkdir build-static
cd build-static

cmake -G "Ninja" ^
      -DCMAKE_PREFIX_PATH=%LIBRARY_PREFIX% ^
      -DCMAKE_INSTALL_PREFIX="%LIBRARY_PREFIX%" ^
      -DCMAKE_INSTALL_LIBDIR=lib ^
      -DCMAKE_BUILD_TYPE=Release ^
      -DBUILD_SHARED_LIBS=OFF ^
      ..
if errorlevel 1 exit 1

ninja install
if errorlevel 1 exit 1
