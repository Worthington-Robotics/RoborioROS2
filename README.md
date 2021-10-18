### Roborio RCLCPP
This is a builder for the ros2 RCLCPP client library and its dependencies for the NI roborio. It currently is only able to use Fast-DDS from e-prosima, but CycloneDDS support is being resolved currently.

## Setup
In order to use this builder tool to release a version of rclcpp for the roborio, the following needs to be set up.
1. Install wpilib on an ubuntu computer, and make sure the C++ devleopment tools are selected
2. Clone this repository into a directory on the desired computer
3. Run the following commands to setup the submodules inside this directory:
```
git submodule init
git submodule update
```
4. You can now add any addtional packages (like message libraries you wish to use).
5. Make sure the host computer has a working installation of ros and colcon.
6. Open a terminal session that does not have any version of ros currently sourced. This is crucial as we cannot pull in the host builds of all the libraries for the roborio build. This can be accomplished by removing the `source /opt/ros/<version>/setup.bash` from your `~/.bashrc` and opening a new terminal session.

## Building
There are 3 main scripts that control the builiding of rclcpp for the roborio. `build.sh`, which orchestrates the whole building process. `download_deps.sh`, which handles downloading dependencies for the roborio and adding them to the cross compilation root. And `mark_ignore_deps.sh`, which creates `COLCON_IGNORE` files on all unnessecary packages needed for running rclcpp on the rio. This is the one that may need addtional changes for any addtional libraries you may want to introduce. There are two other important files, `rio_toolchain.cmake` and `colcon.meta`. `rio_toolchain.cmake` is the toolchain file which cmake uses to produce the library. this points to the rio compilier for the given year. `colcon.meta` is a configuration file for colcon which allows it to turn on and off certian configuration variables based on what packages it is building. this file should not need to be modified. 


In order to build the library for the rio, all you need to invoke is `./build.sh` in a terminal session. It will atuomatically orchestrate the whole build process, and produce the resulting tarball. The tarball will sow up in the root directory with the name `rclcpp_rio.tar` which is a tarball of install and adds some of the needed libraries for deploying to the rio. 

## Usage
For an example use case, please see the RCLCPP Rio Example project. It provides a working `build.gradle` file as well as example code for a node, a publisher and a subscriber. At this time, the rio version of the library does not support using the actionlib or lifecycle systems built into ros, as they do not compile properly. 