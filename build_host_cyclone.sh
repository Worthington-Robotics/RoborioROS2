#!/bin/bash

CYC_HOST_DIR=$(pwd)/cyclone_host/cyclonedds

mkdir ${CYC_HOST_DIR}/build

pushd ${CYC_HOST_DIR}/build > /dev/null

    echo "Building cyclonedds for host"

    cmake -DCMAKE_INSTALL_PREFIX=${CURR_DIR} -DBUILD_EXAMPLES=OFF ..

    cmake --build .

    echo "Adding cyclonedds tools to path for host"

    export PATH=${PATH}:$(pwd)/bin

    echo $PATH

popd > /dev/null