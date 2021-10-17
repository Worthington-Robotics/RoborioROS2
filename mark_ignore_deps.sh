#!/bin/bash

if [[ -z $DDS_IMPL ]]; then
    echo "DDS implementation not set. Please specify an implementation"
    exit -1
fi

pushd $(pwd)/src > /dev/null

    touch ./ros2/rcl/rcl_action/COLCON_IGNORE
    touch ./ros2/rcl/rcl_lifecycle/COLCON_IGNORE

    touch ./ros2/rcl_logging/rcl_logging_log4cxx/COLCON_IGNORE
    touch ./ros2/rcl_logging/rcl_logging_spdlog/COLCON_IGNORE
    touch ./ros2/spdlog_vendor/COLCON_IGNORE

    touch ./ros2/rclcpp/rclcpp_action/COLCON_IGNORE
    touch ./ros2/rclcpp/rclcpp_lifecycle/COLCON_IGNORE
    touch ./ros2/rclcpp/rclcpp_components/COLCON_IGNORE

    touch ./ros2_tracing/ros2_tracing/tracetools_test/COLCON_IGNORE

    if [[ "$DDS_IMPL" == *FastRTPS* ]]; then
        # ignore cyclone and its deps
        touch ./eclipse-cyclonedds/COLCON_IGNORE
        touch ./eclipse-iceoryx/COLCON_IGNORE
        touch ./ros2/rmw_cyclonedds/COLCON_IGNORE
    else
        # ignore rtps and its deps
        touch ./eprosima/COLCON_IGNORE
        touch ./ros2/rmw_fastrtps/COLCON_IGNORE
    fi

popd > /dev/null