#!/bin/bash
cd ~/wpilib/2021/roborio/arm-frc2020-linux-gnueabi
rm ~/2021RobotCode/roscore_roborio.tar.bz2
tar -cf ~/2021RobotCode/roscore_roborio.tar opt/ros/dashing
bzip2 -9 ~/2021RobotCode/roscore_roborio.tar