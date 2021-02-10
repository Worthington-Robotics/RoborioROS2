FROM ros:dashing

# Set vars/locale (some of it probably isn't necessary)
ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=America/New_York
ENV USER_HOME=/home/build

# Copy setup scripts
COPY ./script/ $USER_HOME

# Create a build user and change to their directory
RUN $USER_HOME/make_usr.sh

# Install all dependencies
RUN $USER_HOME/install_deps.sh

# Install ROS2
RUN ${USER_HOME}/setup_rosinstall.sh

# Copy compiliation files
COPY ./build/ $USER_HOME

# Cross compile all dependents by calling all of the cross build scripts in lib 
RUN $USER_HOME/crossbuild_all.sh

# RUN colcon build --merge-install \
#    --cmake-force-configure \
#    --cmake-args \
#    -DCMAKE_TOOLCHAIN_FILE="$USER_HOME/rostoolchain.cmake" \
#    -DCMAKE_INSTALL_PREFIX="usr/arm-frc-linux-gnueabi" \
#    -DCMAKE_BUILD_TYPE=Release .

# Zip file
# RUN ./zip.sh
ENTRYPOINT [ "/bin/bash" ]


