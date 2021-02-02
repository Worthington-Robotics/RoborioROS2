FROM wpilib/roborio-cross-ubuntu:2021-18.04
COPY ./docker/ $HOME
#RUN ./cross_build.sh
RUN apt update
RUN apt-get install -y colcon python3-rosdep2 python3-rosinstall-generator python3-wstool python3-rosinstall build-essential ninja-build
RUN rosdep init
RUN rosdep update
WORKDIR $HOME/dashing_arm
RUN rosinstall_generator ros_core ros_comm robot angles serial robot_localization --rosdistro dashing --deps --wet-only > dashing-ros.rosinstall
WORKDIR $HOME/dashing_arm/src
RUN touch .rosinstall
RUN wstool merge ../dashing-ros.rosinstall
RUN wstool update -j8
RUN colcon build --merge-install \
    --cmake-force-configure \
    --cmake-args -G Ninja \
    -DCMAKE_TOOLCHAIN_FILE="<path_to_toolchain/toolchainfile.cmake>" \
    -DCMAKE_INSTALL_PREFIX=~/wpilib/2021/roborio/arm-frc2020-linux-gnueabi/opt/ros/dashing

ENTRYPOINT [ "/bin/sh" ]


