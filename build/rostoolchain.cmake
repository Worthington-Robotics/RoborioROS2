cmake_minimum_required(VERSION 2.8)
set(CMAKE_SYSTEM_NAME Linux)
set(CMAKE_SYSTEM_PROCESSOR arm)
set(THREADS_PTHREAD_ARG 0)
set(PYTHON_SOABI cpython-36m-arm-linux-gnueabihf)
set(ARM_PREFIX arm-frc-linux-gnueabi)

set(CMAKE_C_COMPILER ${ARM_PREFIX}-gcc)
set(CMAKE_CXX_COMPILER ${ARM_PREFIX}-g++)

# maybe set to ros install
set(CMAKE_SYSROOT /usr/${ARM_PREFIX})

# $ENV{HOME}/2020RobotCode/zebROS_ws/install_isolated
set(CMAKE_FIND_ROOT_PATH opt/ros/dashing)
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)

set(BOOST_ROOT ${ARM_PREFIX})
set(Boost_NO_SYSTEM_PATHS=ON)

find_program(CMAKE_RANLIB ${ARM_PREFIX}-gcc-ranlib)
find_program(CMAKE_AR ${ARM_PREFIX}-gcc-ar)
set(OPT_FLAGS "-O3 -flto=2 -fno-fat-lto-objects -mcpu=cortex-a9 -mfpu=neon -fvect-cost-model -ffunction-sections -fdata-sections -Wl,-gc-sections -Wno-psabi")
set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} ${OPT_FLAGS}")
set(CMAKE_EXE_LINKER_FLAGS_RELEASE "${CMAKE_EXE_LINKER_FLAGS_RELEASE} ${OPT_FLAGS}")
set(CMAKE_INSTALL_RPATH "${USER_HOME}/dashing_arm/opt/ros/dashing/lib")
set(CMAKE_BUILD_WITH_INSTALL_RPATH TRUE)
