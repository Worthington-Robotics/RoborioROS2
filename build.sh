rm -rf build install log

colcon build \
	--merge-install \
	--cmake-args \
	"--no-warn-unused-cli" \
	-DCMAKE_POSITION_INDEPENDENT_CODE:BOOL=ON \
	-DTHIRDPARTY=ON \
	-DBUILD_TESTING=OFF \
	-DCMAKE_BUILD_TYPE=Release \
	-DCMAKE_TOOLCHAIN_FILE=$TOOLCHAIN \
	-DCMAKE_VERBOSE_MAKEFILE=ON


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