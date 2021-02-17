#!/bin/bash
useradd -ms /bin/bash build 
usermod -aG sudo build
echo "build:build" | chpasswd
mkdir -p /home/build
chown -R build /home/build