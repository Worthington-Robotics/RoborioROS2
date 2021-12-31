// Copyright (c) FIRST and other WPILib contributors.
// Open Source Software; you can modify and/or share it under the terms of
// the WPILib BSD license file in the root directory of this project.

#include "Robot.h"
#include <iostream>

void Robot::RobotInit()
{
  frc::DriverStation::GetInstance().ReportWarning("Starting ROS!");

  rclcpp::init(0, NULL);

  frc::DriverStation::GetInstance().ReportWarning("Ros INIT!");

  node = std::make_shared<ros::RosNode>();

  left = std::make_shared<TalonFX>(0);
  right = std::make_shared<TalonFX>(1);
}

void Robot::RobotPeriodic()
{
  //std::cout << "spinning" << std::endl;
  rclcpp::spin_some(node);
}

void Robot::AutonomousInit() {}
void Robot::AutonomousPeriodic() {}

void Robot::TeleopInit() {}
void Robot::TeleopPeriodic()
{
  node->publish();
  double leftData, rightData;
  node->getNewData(leftData, rightData);
  left->Set(ControlMode::PercentOutput, leftData);
  right->Set(ControlMode::PercentOutput, rightData);
}

void Robot::DisabledInit() {}
void Robot::DisabledPeriodic() {}

void Robot::TestInit() {}
void Robot::TestPeriodic() {}

#ifndef RUNNING_FRC_TESTS
int main()
{
  return frc::StartRobot<Robot>();
}
#endif
