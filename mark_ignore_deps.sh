#!/bin/bash

if [[ -z $DDS_IMPL ]]; then
    echo "DDS implementation not set. Please specify an implementation"
    exit -1
fi

pushd $(pwd)/src > /dev/null

    touch ./ros2/rcl/rcl_lifecycle/COLCON_IGNORE

    touch ./ros2/rcl_logging/rcl_logging_log4cxx/COLCON_IGNORE
    touch ./ros2/rcl_logging/rcl_logging_spdlog/COLCON_IGNORE
    touch ./ros2/spdlog_vendor/COLCON_IGNORE

    touch ./ros2/rclcpp/rclcpp_lifecycle/COLCON_IGNORE
    touch ./ros2/rclcpp/rclcpp_components/COLCON_IGNORE

    touch ./ros2_tracing/ros2_tracing/tracetools_test/COLCON_IGNORE

    # ignore our local packages
    touch ./worbots/LimelightROS2/limelight_driver/COLCON_IGNORE
    touch ./worbots/RosPathGen/rospathgen/COLCON_IGNORE
    touch ./worbots/AutonomousBehaviorTree/autonomous_behavior_tree/COLCON_IGNORE
    touch ./worbots/robotTool/robot_tools/COLCON_IGNORE

    if [[ "$DDS_IMPL" == *FastRTPS* ]]; then
        # ignore cyclone and its deps
        touch ./eclipse-cyclonedds/COLCON_IGNORE
        touch ./eclipse-iceoryx/COLCON_IGNORE
        touch ./ros2/rmw_cyclonedds/COLCON_IGNORE

        #remove fastrtps ignores
        rm ./eprosima/COLCON_IGNORE
        rm ./ros2/rmw_fastrtps/COLCON_IGNORE
        rm ./ros2/rosidl_typesupport_fastrtps/COLCON_IGNORE
    else
        # ignore rtps and its deps
        touch ./eprosima/COLCON_IGNORE
        touch ./ros2/rmw_fastrtps/COLCON_IGNORE
        touch ./ros2/rosidl_typesupport_fastrtps/COLCON_IGNORE

        #remove cyclonedds ignores
        rm ./eclipse-cyclonedds/COLCON_IGNORE
        rm ./eclipse-iceoryx/COLCON_IGNORE
        rm ./ros2/rmw_cyclonedds/COLCON_IGNORE
    fi

popd > /dev/null