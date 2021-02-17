FROM ros:dashing

# Install curl and other important pre-tools
RUN apt-get update && apt-get install -q -y --no-install-recommends curl wget gnupg2 lsb-release locales
# Download Roborio toolchain
RUN curl -SL https://github.com/wpilibsuite/roborio-toolchain/releases/download/v2021-2/FRC-2021-Linux-Toolchain-7.3.0.tar.gz | sh -c 'mkdir -p /usr/arm-frc2021-linux-gnueabi && cd /usr/arm-frc2021-linux-gnueabi && tar xzf - --strip-components=2'
RUN apt-get update && apt-get -y --no-install-recommends install git libc6-i386 jstest-gtk meshlab cmake libprotobuf-dev libprotoc-dev protobuf-compiler ninja-build sip-dev python-empy libtinyxml2-dev libeigen3-dev


# Create a build user and change to their directory
RUN useradd -ms /bin/bash build 
RUN usermod -aG sudo build
RUN echo "build:build" | chpasswd
WORKDIR /home/build
RUN chown -R build /home/build

# 
ENV USER_HOME=/home/build
WORKDIR $USER_HOME

# Copy toolchain build file
COPY ./build/ $USER_HOME
# RUN $USER_HOME/compile-lib/tinyxml2.sh
ENTRYPOINT [ "/bin/bash" ]