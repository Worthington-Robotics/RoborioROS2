##configuration
set(YEAR 2021)

# Set system definitions
SET(CMAKE_SYSTEM_NAME Linux)
set(CMAKE_SYSTEM_PROCESSOR arm)
set(CMAKE_CROSSCOMPILING 1)
set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)

set(ARM_PREFIX arm-frc${YEAR}-linux-gnueabi)

set(USER_HOME $ENV{HOME})
set(WPI_DIR ${USER_HOME}/wpilib/${YEAR})
# message("Using wpilib dir ${WPI_DIR}")

set(CMAKE_SYSROOT ${WPI_DIR}/roborio/${ARM_PREFIX})
# message("Using cross root at ${CMAKE_SYSROOT}")

# Use a relative dir to get to the compilier
set(COMPILIER_DIR ${WPI_DIR}/roborio/bin/)

find_program(CMAKE_C_COMPILER NAMES arm-frc2021-linux-gnueabi-gcc PATHS ${COMPILIER_DIR})
find_program(CMAKE_CXX_COMPILER NAMES arm-frc2021-linux-gnueabi-g++ PATHS ${COMPILIER_DIR})
find_program(CMAKE_LINKER NAMES arm-frc2021-linux-gnueabi-gcc PATHS ${COMPILIER_DIR})
find_program(CMAKE_AR NAMES arm-frc2021-linux-gnueabi-ar PATHS ${COMPILIER_DIR})

# message("Got C compilier at ${CMAKE_C_COMPILER}")
# message("Got CXX compilier at ${CMAKE_CXX_COMPILER}")
# message("Got linker at ${CMAKE_LINKER}")
# message("Got ar at ${CMAKE_AR}")

set(CMAKE_FIND_ROOT_PATH ${CMAKE_SYSROOT};${CMAKE_CURRENT_LIST_DIR}/install)
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)

SET(CMAKE_C_COMPILER_WORKS 1 CACHE INTERNAL "")
SET(CMAKE_CXX_COMPILER_WORKS 1 CACHE INTERNAL "")

set(FLAGS "-D'RCUTILS_LOG_MIN_SEVERITY=RCUTILS_LOG_MIN_SEVERITY_NONE' -D_GNU_SOURCE -lpthread" CACHE STRING "" FORCE)

set(CMAKE_C_FLAGS_INIT "-std=c11 ${FLAGS} ${CMAKE_CXX_FLAGS} -fdata-sections -Wa,--noexecstack -fsigned-char -Wno-psabi -fPIC")
set(CMAKE_CXX_FLAGS_INIT "-std=c++17 ${FLAGS} ${CMAKE_C_FLAGS} -fdata-sections -fpermissive -Wa,--noexecstack -fsigned-char -Wno-psabi -fPIC")

set(SOFTFP yes)
set(CMAKE_BUILD_WITH_INSTALL_RPATH TRUE)
