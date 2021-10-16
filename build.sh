# pull in cross root deps and compilier
#./roborio_toolchain/download_deps.sh

# clean the last build if it exists
rm -rf build install log

TOOLCHAIN=$(pwd)/rio_toolchain.cmake
COLCON_META=$(pwd)/colcon.meta

# build it!
colcon build \
	--merge-install \
    --metas ${COLCON_META} \
	--cmake-args \
	"--no-warn-unused-cli" \
	-DTHIRDPARTY=ON \
	-DBUILD_TESTING=OFF \
	-DCMAKE_BUILD_TYPE=Release \
	-DCMAKE_TOOLCHAIN_FILE=${TOOLCHAIN} \
	-DCMAKE_VERBOSE_MAKEFILE=ON

#tar cf rclcpp_rio.tar ./install


# This is for static building, but there seems to be an issue with cycloneDDS
# itself that does not allow for static builds. The solution for now is to use
# the shared library format, and make sure the rio has it installed.

# WORKSPACE=$(pwd)
# EXPORT_DIR=$WORKSPACE/librclcpp
# BUILD_DIR=$WORKSPACE/build

# mkdir -p $EXPORT_DIR; cd $WORKSPACE;
# for file in $(find $WORKSPACE/install/lib/ -name '*.a'); do
# 	folder=$(echo $file | sed -E "s/(.+)\/(.+).a/\2/");
# 	mkdir -p $folder; cd $folder; ar x $file;
# 	for f in *; do
# 		mv $f ../$folder-$f;
# 	done;
# 	cd ..; rm -rf $folder;
# done ;

# ar rc librclcpp.a $(ls *.o *.obj 2> /dev/null)
# mkdir -p $BUILD_DIR;
# cp librclcpp.a $BUILD_DIR; 
# ranlib $BUILD_DIR/librclcpp.a;