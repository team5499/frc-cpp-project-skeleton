cmake_minimum_required(VERSION 2.8)
include(${CMAKE_TOOLCHAIN_FILE})

project(frc-cpp-project-skeleton)
set(TEAM_NUMBER 5499)

# Robot target
# For quick list run
# find src -iname "*.cpp"
# in project root
#set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++14")
set(SOURCE_FILES src/Robot.cpp)
add_executable(${PROJECT_NAME} ${SOURCE_FILES})
find_library(WPILIB wpi)
target_link_libraries(${PROJECT_NAME} ${WPILIB})

# Test target
include(ExternalProject)
ExternalProject_Add(check
  PREFIX ${CMAKE_CURRENT_SOURCE_DIR}/test
  SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/test
  BINARY_DIR ${CMAKE_CURRENT_BINARY_DIR}/test
  STAMP_DIR ${CMAKE_CURRENT_BINARY_DIR}/test/stamp
  INSTALL_COMMAND ""
  TEST_AFTER_INSTALL 1
  TEST_COMMAND ${CMAKE_CURRENT_BINARY_DIR}/test/check)
set_target_properties(check PROPERTIES EXCLUDE_FROM_ALL TRUE)

# Deploy target
find_file(ROBOTCOMMAND ant/robotCommand /usr/share/wpilib)
add_custom_target(deploy
  COMMAND sh -c "./deploy.sh ${TEAM_NUMBER} $<TARGET_FILE:${PROJECT_NAME}> ${ROBOTCOMMAND}"
  DEPENDS ${PROJECT_NAME})
set_target_properties(deploy PROPERTIES EXCLUDE_FROM_ALL TRUE)

# Doxygen target
find_package(Doxygen)
configure_file(Doxyfile.in
  ${CMAKE_CURRENT_BINARY_DIR}/Doxyfile @ONLY)
add_custom_target(doxygen
  ${DOXYGEN_EXECUTABLE} ${CMAKE_CURRENT_BINARY_DIR}/Doxyfile)
set_target_properties(doxygen PROPERTIES EXCLUDE_FROM_ALL TRUE)
