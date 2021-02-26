#!/bin/bash
mkdir -p $USER_HOME/dashing_arm/src
cd $USER_HOME/dashing_arm

# Generate installation setup files
rosinstall_generator ros_core ros_comm --rosdistro dashing --deps --wet-only > dashing-ros.rosinstall
cd $USER_HOME/dashing_arm/src
touch .rosinstall
wstool merge ../dashing-ros.rosinstall
wstool update -j8
cd $USER_HOME/dashing_arm
yes yes | rosdep init -y
yes yes | rosdep update -y
yes yes | rosdep install -i --from-path src --rosdistro dashing -y