#!/bin/bash
wget https://github.com/pocoproject/poco/archive/poco-1.8.0.1-release.tar.gz
tar xzf poco-1.8.0.1-release.tar.gz
cd poco-poco-1.8.0.1-release/
# cmake \
#     -DCMAKE_BUILD_TYPE=Release \
#     -DCMAKE_TOOLCHAIN_FILE=$USER_HOME/arm-frc-gnueabi.toolchain.cmake \
#     -DCMAKE_INSTALL_PREFIX:PATH=/usr/arm-frc-linux-gnueabi \
#     -DCMAKE_POSITION_INDEPENDENT_CODE=ON \
#     -DBUILD_SHARED_LIBS:BOOL=OFF \
#     -DBUILD_STATIC_LIBS:BOOL=ON \
#     -DBUILD_TESTS:BOOL=OFF .
CROSS_COMPILE=/usr/arm-frc2021-linux-gnueabi/bin/arm-frc2021-linux-gnueabi- ./configure --no-tests --no-samples --omit=Data/ODBC,Data/MySQL --minimal --prefix=/usr/arm-frc2021-linux-gnueabi/ --static --cflags="-fPIC"
sudo CROSS_COMPILE=/usr/arm-frc2021-linux-gnueabi/bin/arm-frc2021-linux-gnueabi- make -j4 install
cd
sudo rm -rf poco-1.8.0.1-release.tar.gz poco-poco-1.8.0.1-release