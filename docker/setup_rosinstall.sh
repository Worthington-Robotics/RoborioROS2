#!/bin/bash
mkdir -p $USER_HOME/dashing_arm/src
cd $USER_HOME/dashing_arm

# Generate installation setup files
rosinstall_generator ros_core ros_comm robot angles serial --rosdistro dashing --deps --wet-only > dashing-ros.rosinstall
cd $USER_HOME/dashing_arm/src
touch .rosinstall
wstool merge ../dashing-ros.rosinstall
wstool update -j8