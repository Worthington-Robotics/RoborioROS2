#!/bin/bash
mkdir -p $USER_HOME/foxy_arm/src
cd $USER_HOME/foxy_arm

# Generate installation setup files
rosinstall_generator ros_core ros_comm --rosdistro foxy --deps --wet-only > foxy-ros.rosinstall
cd $USER_HOME/foxy_arm/src
touch .rosinstall
wstool merge ../foxy-ros.rosinstall
wstool update -j8
cd $USER_HOME/foxy_arm
yes yes | rosdep install -i \
    --from-paths src \
    --rosdistro foxy -y \
    --skip-keys "console_bridge fastcdr fastrtps libopensplice69 rti-connext-dds-5.3.1 urdfdom_headers"