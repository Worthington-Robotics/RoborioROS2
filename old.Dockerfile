# This image should theoretically do all of these things
# RUN curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | apt-key add -
# RUN sh -c 'echo "deb [arch=$(dpkg --print-architecture)] http://packages.ros.org/ros2/ubuntu $(lsb_release -cs) main" > /etc/apt/sources.list.d/ros2-latest.list'
# RUN apt-get update
# RUN apt-get install -q -y --no-install-recommends libasio-dev libssl-dev libtinyxml2-dev
# RUN apt-get install -q -y --no-install-recommends python3-colcon-common-extensions python3-rosdep2 build-essential python3-rosinstall-generator python3-wstool python3-rosinstall
FROM ros:dashing

# Set vars/locale
ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=America/New_York
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Install curl and other important pre-tools
RUN apt-get update && apt-get -y --no-install-recommends install curl gnupg2 lsb-release locales
# Download Roborio toolchain
RUN curl -SL https://github.com/wpilibsuite/roborio-toolchain/releases/download/v2021-2/FRC-2021-Linux-Toolchain-7.3.0.tar.gz | sh -c 'mkdir -p /usr/local && cd /usr/local && tar xzf - --strip-components=2'
RUN apt-get install -q -y --no-install-recommends python3-rosinstall-generator python3-wstool python3-rosinstall
RUN apt-get install -q -y --no-install-recommends libasio-dev libssl-dev libtinyxml2-dev
#RUN /bin/bash -c "source /opt/ros/dashing/setup.bash"
# RUN useradd -r -p lol -g sudo build
RUN mkdir -p /home/build
# RUN chown -R build /home/build
# USER build
ENV USER_HOME=/home/build
COPY ./docker/* $USER_HOME
# RUN rosdep update
# what in the world does ros2-linux/share do
# RUN rosdep install --from-paths opt/ros/dashing --ignore-src --rosdistro dashing -y --skip-keys "console_bridge fastcdr fastrtps libopensplice67 libopensplice69 osrf_testing_tools_cpp poco_vendor rmw_connext_cpp rosidl_typesupport_connext_c rosidl_typesupport_connext_cpp rti-connext-dds-5.3.1 tinyxml_vendor tinyxml2_vendor urdfdom urdfdom_headers"
# RUN apt-get install -y libpython3-dev
# RUN pip3 install -U argcomplete
WORKDIR $USER_HOME/dashing_arm
RUN rosinstall_generator ros_core ros_comm robot angles serial --rosdistro dashing --deps --wet-only > dashing-ros.rosinstall
WORKDIR $USER_HOME/dashing_arm/src
RUN touch .rosinstall
RUN wstool merge ../dashing-ros.rosinstall
RUN wstool update -j8
RUN echo "source /opt/ros/dashing/setup.bash"
RUN colcon build --merge-install
# RUN colcon build --merge-install \
#     --cmake-force-configure \
#     --cmake-args \
#     -DCMAKE_TOOLCHAIN_FILE="$USER_HOME/rostoolchain.cmake" \
#     -DCMAKE_INSTALL_PREFIX="usr/local/arm-frc2021-linux-gnueabi /opt/ros/dashing" \
#     -DCMAKE_BUILD_TYPE=Release
# RUN ./zip.sh
ENTRYPOINT [ "/bin/bash" ]


