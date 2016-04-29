cmake_minimum_required(VERSION 3.5)
set(CMAKE_TOOLCHAIN_FILE frc-toolchain.cmake)

project(frc-cpp-project-skeleton)

# Robot target
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++14")

# For quick list run
# find src -iname "*.cpp"
# in project root
set(SOURCE_FILES src/main.cpp)
add_frc_executable(${PROJECT_NAME} ${SOURCE_FILES})

# Deploy target
add_frc_deploy(5499 $<TARGET_FILE:${PROJECT_NAME}>)

# Doxygen target
find_package(Doxygen)
if(DOXYGEN_FOUND)
    configure_file(Doxyfile.in
            ${CMAKE_CURRENT_BINARY_DIR}/Doxyfile @ONLY)
    add_custom_target(${PROJECT_NAME}-doxygen
            ${DOXYGEN_EXECUTABLE} ${CMAKE_CURRENT_BINARY_DIR}/Doxyfile)
endif()
