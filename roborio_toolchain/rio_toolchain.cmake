# micro_ros addtitions 
SET(CMAKE_SYSTEM_NAME Linux)
set(CMAKE_SYSTEM_PROCESSOR arm)
set(CMAKE_CROSSCOMPILING 1)
set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)

set(CMAKE_SYSROOT ${CMAKE_CURRENT_LIST_DIR}/cross_root)

# Use a relative dir to get to the compilier
set(COMPILIER_DIR ${CMAKE_CURRENT_LIST_DIR}/cross_root/usr/bin/)
message("Finding Compilier in directory: ${COMPILIER_DIR}")

find_program(CMAKE_C_COMPILER NAMES arm-frc2021-linux-gnueabi-gcc PATHS ${COMPILIER_DIR})
find_program(CMAKE_CXX_COMPILER NAMES arm-frc2021-linux-gnueabi-g++ PATHS ${COMPILIER_DIR})
#find_program(CMAKE_LINKER NAMES arm-frc2021-linux-gnueabi-ld PATHS ${COMPILIER_DIR})
#find_program(CMAKE_AR NAMES arm-frc2021-linux-gnueabi-ar PATHS ${COMPILIER_DIR})

message("Got C compilier at ${CMAKE_C_COMPILER}")
message("Got CXX compilier at ${CMAKE_CXX_COMPILER}")

# Fix UDP transport for linux
set(UCLIENT_PLATFORM_LINUX ON)

SET(CMAKE_C_COMPILER_WORKS 1 CACHE INTERNAL "")
SET(CMAKE_CXX_COMPILER_WORKS 1 CACHE INTERNAL "")

set(FLAGS "-D'RCUTILS_LOG_MIN_SEVERITY=RCUTILS_LOG_MIN_SEVERITY_NONE' -D_GNU_SOURCE -fPIC" CACHE STRING "" FORCE)

set(CMAKE_C_FLAGS_INIT "-std=c11 ${FLAGS} ${CMAKE_CXX_FLAGS} -fdata-sections -Wa,--noexecstack -fsigned-char -Wno-psabi")
set(CMAKE_CXX_FLAGS_INIT "-std=c++17 ${FLAGS} ${CMAKE_C_FLAGS} -fdata-sections -Wa,--noexecstack -fsigned-char -Wno-psabi")
set(SOFTFP yes)
