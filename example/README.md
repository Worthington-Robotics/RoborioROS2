# Roborio RCLCPP Example

To build the project untar the rclcpp_rio.tar in the top level directory. The Build.gradle should automatically import RCLCPP and its dependencies as needed. It will also deploy them to a running roborio. The only exception on deployment is libbison, which has to be installed onto the rio before running via the following opkg command command on a roborio connected to the internet `opkg install bison`.


## Notes About Example Code
This code serves as an example use case of rclcpp running on the roborio. It is able to communicate using the fastrtps protocol to the rest of the ros network. There are two primary files Robot.cpp and RosNode.cpp. 

### Robot.cpp
The robot file is representing any normal robot code from a wpilib robot project. It is responsible for intializing rclcpp and the ros node instance. It is also resposible for spinning rclcpp (IE handling subscriptions and other events) while the robot is running. 

### RosNode.cpp
The RosNode file is resposible for creating the ros node and setting up subscribers and publishers. It has external methods to retrieve data and send data as it comes in from the rest of the ros network. This implementation is an example and follows the patterns from the ros2 docs. https://docs.ros.org/