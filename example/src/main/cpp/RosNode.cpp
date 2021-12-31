#include "RosNode.hpp"
#include <iostream>
#include <frc/Timer.h>
#include <frc/DriverStation.h>
#include <memory>

using std::placeholders::_1;

namespace ros
{
    RosNode::RosNode() : Node("minimal_rio")
    {
        std::cout << "creating publisher" << std::endl;
        publisher_ = this->create_publisher<geometry_msgs::msg::Twist>("/drive/stick", 10);

        std::cout << "creating subscriber" << std::endl;
        leftSub = this->create_subscription<std_msgs::msg::Float32>("/left", 10, std::bind(&RosNode::leftSubCallback, this, _1));
        rightSub = this->create_subscription<std_msgs::msg::Float32>("/right", 10, std::bind(&RosNode::rightSubCallback, this, _1));
    }

    void RosNode::publish()
    {
        auto message = geometry_msgs::msg::Twist();

        message.linear.x = frc::DriverStation::GetInstance().GetStickAxis(0, 0);
        message.angular.z = frc::DriverStation::GetInstance().GetStickAxis(0, 2);

        publisher_->publish(message);

        //std::cout << "message published" << std::endl;
    }

    void RosNode::getNewData(double &left, double &right)
    {
        //safely update motors
        if (lastTime + 0.3 > frc::Timer::GetFPGATimestamp())
        {
            left = lastLeft;
            right = lastRight;
        }
        else
        {
            left = right = 0;
        }
    }

    void RosNode::leftSubCallback(const std_msgs::msg::Float32::SharedPtr msg)
    {
        lastTime = frc::Timer::GetFPGATimestamp();
        lastLeft = msg->data;
    }

    void RosNode::rightSubCallback(const std_msgs::msg::Float32::SharedPtr msg)
    {
        lastTime = frc::Timer::GetFPGATimestamp();
        lastRight = msg->data;
    }
} // namespace ros
