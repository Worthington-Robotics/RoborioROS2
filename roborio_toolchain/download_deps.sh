CURR_DIR=$(pwd)

downloadDep(){
    wget -P ./downloads https://download.ni.com/ni-linux-rt/feeds/2021.0/arm/main/cortexa9-vfpv3/$1
    ar x ./downloads/$1
    tar xf ./data.tar.xz
}

pushd $CURR_DIR/roborio_toolchain > /dev/null

    rm -rf ./frc2021 ./cross_root
    mkdir ./cross_root

    pushd ./cross_root > /dev/null

        rm -rf ./downloads
        mkdir ./downloads
        mkdir ./usr

         #unpack the rio compilier
        echo "Unpacking Rio Compilier and configuring cross root"
        tar xf ../FRC-2021-Linux-Toolchain-7.3.0.tar.gz

        echo ""
        echo ""
        echo "Downloading system dependencies"
        echo ""
        echo ""

        # get Bison
        downloadDep "bison_3.0.4-r0.298_cortexa9-vfpv3.ipk"
        downloadDep "bison-dev_3.0.4-r0.298_cortexa9-vfpv3.ipk"

        # get libssl
        downloadDep "libssl1.0.2_1.0.2u-r0.0_cortexa9-vfpv3.ipk"

        # get libcrypto
        downloadDep "libcrypto1.0.2_1.0.2u-r0.0_cortexa9-vfpv3.ipk"

        # get openssl
        downloadDep "openssl_1.0.2u-r0.0_cortexa9-vfpv3.ipk"
        downloadDep "openssl-dev_1.0.2u-r0.0_cortexa9-vfpv3.ipk"

        # get acl 
        downloadDep "acl_2.2.52-r0.240_cortexa9-vfpv3.ipk"
        downloadDep "acl-dev_2.2.52-r0.240_cortexa9-vfpv3.ipk"

        #get python3
        #downloadDep "python3-core_3.5.5-r1.0.82_cortexa9-vfpv3.ipk"
        downloadDep "python3-dev_3.5.5-r1.0.82_cortexa9-vfpv3.ipk"

        echo ""
        echo ""
        echo "Downloaded system dependencies. Cleaning up"
        echo ""
        echo ""

        # cleanup tar archives
        rm -f control.tar.gz data.tar.xz debian-binary

    popd >/dev/null
popd >/dev/null