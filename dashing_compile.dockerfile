FROM ros:foxy

# Set vars/locale (some of it probably isn't necessary)
ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=America/New_York
ENV USER_HOME=/home/build
# Because...
ENV RTI_NC_LICENSE_ACCEPTED=yes

# Create a build user and change to their directory
COPY ./build/setup/make_usr.sh $USER_HOME/setup/make_usr.sh
RUN $USER_HOME/setup/make_usr.sh

# Install all dependencies
COPY ./build/setup/install_deps.sh $USER_HOME/setup/install_deps.sh
RUN $USER_HOME/setup/install_deps.sh

# Install ROS2
COPY ./build/setup/setup_rosinstall.sh $USER_HOME/setup/setup_rosinstall.sh
RUN $USER_HOME/setup/setup_rosinstall.sh

# Copy compiliation library scripts
COPY ./build/cmake/ $USER_HOME/cmake/
COPY ./build/compile-lib/ $USER_HOME/compile-lib/

WORKDIR $USER_HOME/usr/arm-frc2021-linux-gnueabi

# Cross compile all dependents by calling all of the cross build scripts in lib 
COPY ./build/setup/crossbuild_libs.sh $USER_HOME/setup/crossbuild_libs.sh
RUN $USER_HOME/setup/crossbuild_libs.sh

# RUN cd $USER_HOME/foxy_arm \
#     && . /opt/ros/foxy/setup.sh \
#     && colcon build --merge-install \
#    --cmake-force-configure \
#    --cmake-args \
#    -DCMAKE_TOOLCHAIN_FILE="$USER_HOME/cmake/arm-frc-gnueabi.toolchain.cmake" \
#    -DCMAKE_INSTALL_PREFIX="$USER_HOME/arm-frc2021-linux-gnueabi/opt/ros/foxy" \
#    -DCMAKE_BUILD_TYPE=Release \
#    -DBUILD_TESTING=OFF \
#    --no-warn-unused-cli \
#     && source $USER_HOME/foxy_arm/install/setup.bash

WORKDIR $USER_HOME/foxy_arm
COPY ./build/setup/crossbuild_all.sh $USER_HOME/setup/crossbuild_all.sh
RUN $USER_HOME/setup/crossbuild_all.sh

# Zip file
# RUN ./zip.sh