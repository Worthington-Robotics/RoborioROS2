FROM wpilib/roborio-cross-ubuntu:2021-18.04
COPY ./docker/ $HOME
# RUN echo "uncomment to rebuild from here"
RUN apt-get update
RUN apt-get -y install curl gnupg2 lsb-release
RUN curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | apt-key add -
RUN sh -c 'echo "deb [arch=$(dpkg --print-architecture)] http://packages.ros.org/ros2/ubuntu $(lsb_release -cs) main" > /etc/apt/sources.list.d/ros2-latest.list'
RUN apt-get update
RUN apt-get install -y python3-colcon-common-extensions python3-rosdep2 python3-rosinstall-generator python3-wstool python3-rosinstall build-essential ninja-build
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
    -DCMAKE_TOOLCHAIN_FILE="~/rostoolchain.cmake" \
    -DCMAKE_INSTALL_PREFIX="~/wpilib/2021/roborio/arm-frc2020-linux-gnueabi/opt/ros/dashing" \
    -DCMAKE_BUILD_TYPE=Release
RUN ./zip.sh
ENTRYPOINT [ "/bin/bash" ]


