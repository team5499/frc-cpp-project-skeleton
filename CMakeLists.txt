cmake_minimum_required(VERSION 2.8)
include(frc.cmake)

project(frc-cpp-project-skeleton)

# Robot target
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++14")

# For quick list run
# find src -iname "*.cpp"
# in project root
set(SOURCE_FILES src/Robot.cpp)
add_frc_executable(${PROJECT_NAME} ${SOURCE_FILES})

# Test target
include(ExternalProject)
ExternalProject_Add(ci-test
    PREFIX ${CMAKE_CURRENT_SOURCE_DIR}/test
    SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/test
    BINARY_DIR ${CMAKE_CURRENT_BINARY_DIR}/test
    STAMP_DIR ${CMAKE_CURRENT_BINARY_DIR}/test/stamp
    INSTALL_COMMAND ""
    TEST_AFTER_INSTALL 1
    TEST_COMMAND ${CMAKE_CURRENT_BINARY_DIR}/test/ci-test)
set_target_properties(ci-test PROPERTIES EXCLUDE_FROM_ALL TRUE)

# Deploy target
add_frc_deploy(deploy 5499 $<TARGET_FILE:${PROJECT_NAME}>)

# Doxygen target
find_package(Doxygen)
if(DOXYGEN_FOUND)
    configure_file(Doxyfile.in
            ${CMAKE_CURRENT_BINARY_DIR}/Doxyfile @ONLY)
    add_custom_target(doxygen
            ${DOXYGEN_EXECUTABLE} ${CMAKE_CURRENT_BINARY_DIR}/Doxyfile)
    set_target_properties(doxygen PROPERTIES EXCLUDE_FROM_ALL TRUE)
endif()
