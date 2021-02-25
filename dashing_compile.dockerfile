FROM ros:dashing

# Set vars/locale (some of it probably isn't necessary)
ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=America/New_York
ENV USER_HOME=/home/build

# Copy setup scripts
COPY ./build/setup/ $USER_HOME/setup/

# Create a build user and change to their directory
RUN $USER_HOME/setup/make_usr.sh

# Install all dependencies
RUN $USER_HOME/setup/install_deps.sh

# Install ROS2
RUN $USER_HOME/setup/setup_rosinstall.sh

# Copy compiliation library scripts
COPY ./build/cmake/ $USER_HOME/cmake/
COPY ./build/compile-lib/ $USER_HOME/compile-lib/

# Cross compile all dependents by calling all of the cross build scripts in lib 
# RUN $USER_HOME/setup/crossbuild_all.sh

WORKDIR $USER_HOME/dashing_arm

RUN colcon build --merge-install \
   --cmake-force-configure \
   --cmake-args \
   -DCMAKE_TOOLCHAIN_FILE="$USER_HOME/cmake/arm-frc-gnueabi.toolchain.cmake" \
   -DCMAKE_INSTALL_PREFIX="$USER_HOME/arm-frc2021-linux-gnueabi/opt/ros/dashing" \
   -DCMAKE_BUILD_TYPE=Release .

# Zip file
# RUN ./zip.sh


