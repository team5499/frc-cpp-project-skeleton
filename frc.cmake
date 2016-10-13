find_file(ARM_TOOLCHAIN arm-toolchain.cmake PATHS ${CMAKE_CURRENT_SOURCE_DIR} NO_DEFAULT_PATH)
if(${ARM_TOOLCHAIN} STREQUAL ARM_TOOLCHAIN-NOTFOUND)
    message(STATUS "arm-toolchain not found... downloading from usfirst.collab.net...")
    execute_process(COMMAND wget
                    -O ${CMAKE_CURRENT_SOURCE_DIR}/arm-toolchain.cmake
                    "https://usfirst.collab.net/gerrit/gitweb?p=allwpilib.git;a=blob_plain;f=arm-toolchain.cmake;hb=HEAD")
    find_file(ARM_TOOLCHAIN arm-toolchain.cmake PATHS ${CMAKE_CURRENT_SOURCE_DIR} NO_DEFAULT_PATH)
    if(${ARM_TOOLCHAIN} STREQUAL ARM_TOOLCHAIN-NOTFOUND)
        message(FATAL_ERROR "arm-toolchain still not found. Aborting.")
    endif()
endif()
set(CMAKE_TOOLCHAIN_FILE ${ARM_TOOLCHAIN})

set(WPILIB_HOME /usr/wpilib)

include_directories(${WPILIB_HOME}/include)
link_directories(${WPILIB_HOME}/lib)

function(add_frc_executable _NAME)
    add_executable(${ARGV})
    target_link_libraries(${_NAME} libwpi.so)
endfunction()

function(add_frc_deploy TARGET_NAME TEAM_NUMBER ROBOT_EXECUTABLE)
    add_custom_target(${TARGET_NAME}
	COMMAND sh -c "./deploy.sh ${TEAM_NUMBER} ${ROBOT_EXECUTABLE} ${WPILIB_HOME}/ant/robotCommand"
	DEPENDS ${PROJECT_NAME})
    set_target_properties(${TARGET_NAME} PROPERTIES EXCLUDE_FROM_ALL TRUE)
endfunction()
