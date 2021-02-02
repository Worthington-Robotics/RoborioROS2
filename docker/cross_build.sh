#!/bin/bash
mkdir ~/dashing_arm
mkdir -p ~/dashing_arm/src

apt update
apt install -y catkin python3-rosdep2 python3-rosinstall-generator python3-wstool python3-rosinstall build-essential ninja-build
rosdep init
rosdep update

cd ~/dashing_arm

# robot, ros_comm, serial do not exist
rosinstall_generator ros_core ros_comm robot angles serial robot_localization --rosdistro dashing --deps --wet-only > dashing-ros.rosinstall

cd ~/dashing_arm/src

touch .rosinstall
wstool merge ../dashing-ros.rosinstall
wstool update -j8

catkin_make_isolated --install --use-ninja -DCMAKE_INSTALL_PREFIX=~/wpilib/2021/roborio/arm-frc2020-linux-gnueabi/opt/ros/dashing -DCMAKE_BUILD_TYPE=Release -DCMAKE_TOOLCHAIN_FILE=~/rostoolchain.cmake -DCATKIN_ENABLE_TESTING=OFF

cd ~/wpilib/2021/roborio/arm-frc2020-linux-gnueabi
rm ~/2021RobotCode/roscore_roborio.tar.bz2
tar -cf ~/2021RobotCode/roscore_roborio.tar opt/ros/dashing
bzip2 -9 ~/2021RobotCode/roscore_roborio.tar