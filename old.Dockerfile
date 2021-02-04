FROM ros:dashing

# Set vars/locale (some of it probably isn't necessary)
ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=America/New_York

# Install curl and other important pre-tools
RUN apt-get update && apt-get install -q -y --no-install-recommends curl gnupg2 lsb-release locales
# Install ROS packages
RUN apt-get install -q -y --no-install-recommends python3-rosinstall-generator python3-wstool python3-rosinstall libasio-dev libssl-dev libtinyxml2-dev
# Download Roborio toolchain
RUN curl -SL https://github.com/wpilibsuite/roborio-toolchain/releases/download/v2021-2/FRC-2021-Linux-Toolchain-7.3.0.tar.gz | sh -c 'mkdir -p /usr/local && cd /usr/local && tar xzf - --strip-components=2'
# Create a build user and change to their directory
RUN useradd -ms /bin/bash build 
RUN usermod -aG sudo build
RUN echo "build:build" | chpasswd
WORKDIR /home/build
RUN chown -R build /home/build
# Add user variable and copy toolchain build file
ENV USER_HOME=/home/build
COPY ./docker/* $USER_HOME
# Install ROS2
WORKDIR $USER_HOME/dashing_arm
RUN rosinstall_generator ros_core ros_comm robot angles serial --rosdistro dashing --deps --wet-only > dashing-ros.rosinstall
WORKDIR $USER_HOME/dashing_arm/src
RUN touch .rosinstall
RUN wstool merge ../dashing-ros.rosinstall
RUN wstool update -j8

# Compile (hopefully cross-compile soon)
RUN colcon build --merge-install
# RUN colcon build --merge-install \
#     --cmake-force-configure \
#     --cmake-args \
#     -DCMAKE_TOOLCHAIN_FILE="$USER_HOME/rostoolchain.cmake" \
#     -DCMAKE_INSTALL_PREFIX="usr/local/arm-frc2021-linux-gnueabi /opt/ros/dashing" \
#     -DCMAKE_BUILD_TYPE=Release

# Zip file
# RUN ./zip.sh
ENTRYPOINT [ "/bin/bash" ]


