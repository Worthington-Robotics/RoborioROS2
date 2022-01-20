#!/bin/bash

CYC_HOST_DIR=$(pwd)/cyclone_host/cyclonedds

mkdir ${CYC_HOST_DIR}/build

sudo apt install bison -y

pushd ${CYC_HOST_DIR}/build > /dev/null

    echo "Building cyclonedds for host"

    cmake -DCMAKE_INSTALL_PREFIX=$(pwd) -DBUILD_EXAMPLES=OFF ..

    cmake --build .

    echo "Adding cyclonedds tools to path for host"

    export PATH=${PATH}:$(pwd)/bin

popd > /dev/null