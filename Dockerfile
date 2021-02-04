#RUN echo "uncomment to rebuild from here"
FROM ubuntu:20.04
ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=America/New_York
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN apt-get update
RUN apt-get -y install curl gnupg2 lsb-release
RUN curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | apt-key add -
RUN sh -c 'echo "deb [arch=$(dpkg --print-architecture)] http://packages.ros.org/ros2/ubuntu $(lsb_release -cs) main" > /etc/apt/sources.list.d/ros2-latest.list'
RUN apt-get update
# REMOVE NINJA! 
RUN apt-get install -y python3-colcon-common-extensions python3-rosdep2 python3-rosinstall-generator python3-wstool python3-rosinstall build-essential ninja-build
# SPECIFIC for ROS2 (maybe we don't need it)
RUN apt-get install -y libasio-dev libtinyxml2-dev 
RUN curl -SL https://github.com/wpilibsuite/roborio-toolchain/releases/download/v2021-2/FRC-2021-Linux-Toolchain-7.3.0.tar.gz | sh -c 'mkdir -p /usr/local && cd /usr/local && tar xzf - --strip-components=2'
#RUN /bin/bash -c "source /opt/ros/dashing/setup.bash"
RUN useradd -r -g users build
RUN mkdir -p /home/build
RUN chown -R build /home/build
USER build
ENV USER_HOME=/home/build
COPY ./docker/* $USER_HOME
RUN rosdep update
# what in the world does ros2-linux/share do
RUN rosdep install --from-paths ros2-linux/share --ignore-src --rosdistro dashing -y --skip-keys "console_bridge fastcdr fastrtps libopensplice67 libopensplice69 osrf_testing_tools_cpp poco_vendor rmw_connext_cpp rosidl_typesupport_connext_c rosidl_typesupport_connext_cpp rti-connext-dds-5.3.1 tinyxml_vendor tinyxml2_vendor urdfdom urdfdom_headers"
RUN sudo apt install -y libpython3-dev python3-pip
RUN pip3 install -U argcomplete
WORKDIR $USER_HOME/dashing_arm
RUN rosinstall_generator ros_core ros_comm robot angles serial robot_localization --rosdistro dashing --deps --wet-only > dashing-ros.rosinstall
WORKDIR $USER_HOME/dashing_arm/src
RUN touch .rosinstall
RUN wstool merge ../dashing-ros.rosinstall
RUN wstool update -j8
RUN colcon build --merge-install \
    --cmake-force-configure \
    --cmake-args \
    -DCMAKE_TOOLCHAIN_FILE="$USER_HOME/rostoolchain.cmake" \
    -DCMAKE_INSTALL_PREFIX="usr/local/arm-frc2021-linux-gnueabi /opt/ros/dashing" \
    -DCMAKE_BUILD_TYPE=Release
# RUN ./zip.sh
ENTRYPOINT [ "/bin/bash" ]


