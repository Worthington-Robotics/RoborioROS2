#!/bin/bash
source /opt/ros/${ROS_DISTRO}/setup.bash

colcon build --merge-install \
   --cmake-force-configure \
   --cmake-args \
   -DCMAKE_TOOLCHAIN_FILE="$USER_HOME/cmake/arm-frc-gnueabi.toolchain.cmake" \
   -DCMAKE_INSTALL_PREFIX="$USER_HOME/arm-frc2021-linux-gnueabi/opt/ros/foxy" \
   -DCMAKE_BUILD_TYPE=Release \
   -DBUILD_TESTING=OFF \
   -Wno-dev \
   --no-warn-unused-cli