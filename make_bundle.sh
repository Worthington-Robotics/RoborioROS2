#!/bin/bash

echo "Adding build deps to bundle"
# Get extra deps for export

cp extra_libs/usr/lib/* install/lib/	# for most libs
cp extra_libs/lib/* install/lib/		# for some libs

rm rclcpp_rio.tar

tar chf rclcpp_rio.tar ./install