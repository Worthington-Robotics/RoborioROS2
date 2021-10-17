#!/bin/bash

if [[ -z $CROSS_ROOT ]]; then
    echo "Cross root not set. Please specify a cross root"
    exit -1
fi

downloadDep(){
    # make sure the release year and versions for the package match the opkg list on the RIO
    wget -P ./downloads https://download.ni.com/ni-linux-rt/feeds/2019/arm/cortexa9-vfpv3/$1
    ar x ./downloads/$1

    # Setup default arg for this function
    if [[ -z $2 ]]; then
        EXT=gz
    else
        EXT=$2
    fi

    tar xf ./data.tar.${EXT}
}

export -f downloadDep

pushd ${CROSS_ROOT} > /dev/null

    rm -rf ./downloads
    mkdir ./downloads

    echo ""
    echo ""
    echo "Downloading system dependencies"
    echo ""
    echo ""

    # get Bison
    downloadDep "bison-dev_3.0.4-r0.256_cortexa9-vfpv3.ipk"
    downloadDep "bison-dev_3.0.4-r0.256_cortexa9-vfpv3.ipk"

    # get libssl
    downloadDep "libssl1.0.2_1.0.2o-r0.16_cortexa9-vfpv3.ipk"

    # get openssl
    downloadDep "openssl_1.0.2o-r0.16_cortexa9-vfpv3.ipk"
    downloadDep "openssl-dev_1.0.2o-r0.16_cortexa9-vfpv3.ipk"

    # get libstdc++ 
    downloadDep "libstdc++-dev_7.3.0-r0.16_cortexa9-vfpv3.ipk"
    downloadDep "libstdc++6_7.3.0-r0.16_cortexa9-vfpv3.ipk"

    # get libc
    downloadDep "libc6_2.24-r0.79_cortexa9-vfpv3.ipk"
    downloadDep "libc6-dev_2.24-r0.79_cortexa9-vfpv3.ipk"
    downloadDep "libc6-extra-nss_2.24-r0.79_cortexa9-vfpv3.ipk"
    downloadDep "linux-libc-headers-dev_4.15.7-r0.13_cortexa9-vfpv3.ipk"
    downloadDep "libcidn1_2.24-r0.79_cortexa9-vfpv3.ipk"

    # get libcrypto
    downloadDep "libcrypto1.0.2_1.0.2o-r0.16_cortexa9-vfpv3.ipk"

    # create symlink for pthread to pthreads (fixes fastrtps being dumb)
    ln -s ${CROSS_ROOT}/lib/libpthread.so.0 ${CROSS_ROOT}/lib/libpthreads.so

    # get acl 
    downloadDep "acl_2.2.52-r0.183_cortexa9-vfpv3.ipk"
    downloadDep "acl-dbg_2.2.52-r0.183_cortexa9-vfpv3.ipk"
    downloadDep "acl-dev_2.2.52-r0.183_cortexa9-vfpv3.ipk"
    downloadDep "libacl1_2.2.52-r0.183_cortexa9-vfpv3.ipk"

    # get libattr
    downloadDep "libattr1_2.4.47-r0.513_cortexa9-vfpv3.ipk"

    #get python3
    #downloadDep "python3-core_3.5.5-r1.0.51_cortexa9-vfpv3.ipk"
    downloadDep "python3-dev_3.5.5-r1.0.19_cortexa9-vfpv3.ipk" "gz"

    echo ""
    echo ""
    echo "Downloaded system dependencies. Cleaning up"
    echo ""
    echo ""

    # cleanup tar archives
    rm -f control.tar.* data.tar.* debian-binary

popd >/dev/null