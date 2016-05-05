cmake_minimum_required(VERSION 2.8)

project(ci-test)

# For quick list run
# find src -iname "*.cpp"
set(SOURCE_FILES src/main.cpp)
add_executable(ci-test ${SOURCE_FILES})
