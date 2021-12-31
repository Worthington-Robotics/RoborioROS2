#pragma once

#include <chrono>
#include <functional>
#include <memory>
#include <string>

#include "rclcpp/rclcpp.hpp"
#include "geometry_msgs/msg/twist.hpp"
#include "std_msgs/msg/float32.hpp"

using namespace std::chrono_literals;

namespace ros
{
    class RosNode : public rclcpp::Node
    {
    public:
        RosNode();

        void publish();

        void getNewData(double &left, double &right);

    protected:
        void leftSubCallback(const std_msgs::msg::Float32::SharedPtr msg);

        void rightSubCallback(const std_msgs::msg::Float32::SharedPtr msg);

        rclcpp::Publisher<geometry_msgs::msg::Twist>::SharedPtr publisher_;
        rclcpp::Subscription<std_msgs::msg::Float32>::SharedPtr leftSub, rightSub;
        double lastLeft, lastRight, lastTime = 0;
    };
} // namespace ros
