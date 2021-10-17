#!/bin/bash
TINY_DIR=$(pwd)/tinyxml2_target/tinyxml2

INSTALL_DIR=$(pwd)/install

mkdir -p ${TINY_DIR}/build

# Setup default arg for this function
if [[ -z $TOOLCHAIN ]]; then
    echo "No toolchain given for tinyxml build"
    TOOLCHAIN=$(pwd)/rio_toolchain.cmake
fi

if [[ -z $CROSS_ROOT ]]; then
    echo "Cross root not set. Please specify a cross root"
    exit -1
fi

echo "Building tinyxml2 for target"

# echo "Using toolchain ${TOOLCHAIN}"

pushd ${TINY_DIR}/build > /dev/null

    # configure the build
    cmake -Dtinyxml2_BUILD_TESTING=OFF  -Dtinyxml2_SHARED_LIBS=ON  -DCMAKE_TOOLCHAIN_FILE=${TOOLCHAIN} ..

    # Build the library
    cmake --build .

    echo "Copying tinyxml2 files to cross root"

    # Copy the library to the sysroot
    for file in libtinyxml*; do cp $file ${CROSS_ROOT}/lib; done

    # Copy it into install too
    for file in libtinyxml*; do cp $file ${INSTALL_DIR}/lib/; done

    # Copy the headerfile
    cp ../tinyxml2.h ${CROSS_ROOT}/usr/include

    cp ../tinyxml2.h ${INSTALL_DIR}/include

popd > /dev/null