#!/bin/bash

echo "Adding build deps to bundle"
# Get extra deps for export

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

#TODO Rework this to pull in from lib in cross root
rm -rf extra_libs
mkdir extra_libs
pushd ./extra_libs > /dev/null
	# get ssl
	downloadDep "libssl1.0.2_1.0.2o-r0.16_cortexa9-vfpv3.ipk"

	# get openssl
	downloadDep "openssl_1.0.2o-r0.16_cortexa9-vfpv3.ipk"

	# get libcrypto
	downloadDep "libcrypto1.0.2_1.0.2o-r0.16_cortexa9-vfpv3.ipk"

	# get bison
	downloadDep "bison_3.0.4-r0.256_cortexa9-vfpv3.ipk"

	# get python 3.5
	downloadDep "libpython3.5m1.0_3.5.5-r1.0.19_cortexa9-vfpv3.ipk"
	downloadDep "python3-core_3.5.5-r1.0.51_cortexa9-vfpv3.ipk"
    downloadDep "python3-dev_3.5.5-r1.0.19_cortexa9-vfpv3.ipk" "gz"

	# get ACL 
	downloadDep "acl_2.2.52-r0.183_cortexa9-vfpv3.ipk"
	downloadDep "libacl1_2.2.52-r0.183_cortexa9-vfpv3.ipk"

	# get libattr
	downloadDep "libattr1_2.4.47-r0.513_cortexa9-vfpv3.ipk"

popd >/dev/null

cp extra_libs/usr/lib/* install/lib/	# for most libs
cp extra_libs/lib/* install/lib/		# for some libs

rm rclcpp_rio.tar

tar chf rclcpp_rio.tar ./install