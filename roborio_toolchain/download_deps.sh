cd cross_root

mkdir ./downloads
rm -rf ./downloads

#unpack the rio compilier
tar xvf ../FRC-2021-Linux-Toolchain-7.3.0.tar.gz
mkdir ./usr
mv frc2021/roborio/* ./usr
rm -rf frc2021/roborio/

# get Bison
wget -P ./downloads https://download.ni.com/ni-linux-rt/feeds/2021.0/arm/main/cortexa9-vfpv3/bison_3.0.4-r0.298_cortexa9-vfpv3.ipk
ar xv ./downloads/bison_3.0.4-r0.298_cortexa9-vfpv3.ipk
tar xvf ./data.tar.xz

# get libssl
wget -P ./downloads https://download.ni.com/ni-linux-rt/feeds/2021.0/arm/main/cortexa9-vfpv3/libssl1.0.2_1.0.2u-r0.0_cortexa9-vfpv3.ipk
ar xv ./downloads/libssl1.0.2_1.0.2u-r0.0_cortexa9-vfpv3.ipk
tar xvf ./data.tar.xz

# get openssl
wget -P ./downloads https://download.ni.com/ni-linux-rt/feeds/2021.0/arm/main/cortexa9-vfpv3/openssl_1.0.2u-r0.0_cortexa9-vfpv3.ipk
ar xv ./downloads/openssl_1.0.2u-r0.0_cortexa9-vfpv3.ipk
tar xvf ./data.tar.xz