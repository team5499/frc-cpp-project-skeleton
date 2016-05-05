find_file(ARM_TOOLCHAIN arm-toolchain.cmake PATHS ${CMAKE_CURRENT_SOURCE_DIR} NO_DEFAULT_PATH)
if(${ARM_TOOLCHAIN} STREQUAL ARM_TOOLCHAIN-NOTFOUND)
    message(STATUS "arm-toolchain not found... downloading from usfirst.collab.net...")
    execute_process(COMMAND wget
                    -O arm-toolchain.cmake
                    "https://usfirst.collab.net/gerrit/gitweb?p=allwpilib.git;a=blob_plain;f=arm-toolchain.cmake;hb=HEAD")
    find_file(ARM_TOOLCHAIN arm-toolchain.cmake PATHS ${CMAKE_CURRENT_SOURCE_DIR} NO_DEFAULT_PATH)
    if(${ARM_TOOLCHAIN} STREQUAL ARM_TOOLCHAIN-NOTFOUND)
        message(FATAL_ERROR "arm-toolchain still not found. Aborting.")
    endif()
endif()
set(CMAKE_TOOLCHAIN_FILE ${ARM_TOOLCHAIN})

set(WPILIB_HOME $ENV{HOME}/wpilib/cpp/current)
include_directories(SYSTEM ${WPILIB_HOME}/include)
link_directories(SYSTEM ${WPILIB_HOME}/lib)

function(add_frc_executable _NAME)
    add_executable(${ARGV})
    target_link_libraries(${_NAME} libwpi.so)
endfunction()

function(add_frc_deploy TEAM_NUMBER ROBOT_EXECUTABLE)
    set(TARGET roboRIO-${TEAM_NUMBER}-FRC.local)
    set(USERNAME lvuser)
    set(DEPLOY_DIR /home/lvuser)

    find_program(SSH_EXECUTABLE ssh)
    find_program(SCP_EXECUTABLE scp)

    if(SSH_EXECUTABLE AND SCP_EXECUTABLE)
        add_custom_target(${PROJECT_NAME}-deploy
                COMMAND ssh
                ${USERNAME}@${TARGET}
                rm -f ${DEPLOY_DIR}/FRCUserProgram

                COMMAND scp
                ${ROBOT_EXECUTABLE}
                ${USERNAME}@${TARGET}:${DEPLOY_DIR}/FRCUserProgram

                COMMAND ssh
                ${USERNAME}@${TARGET}
                killall -q netconsole-host || :

                COMMAND scp
                ${WPILIB_HOME}/ant/robotCommand
                ${USERNAME}@${TARGET}:${DEPLOY_DIR}

                COMMAND ssh
                ${USERNAME}@${TARGET}
                . /etc/profile.d/natinst-path.sh;
                chmod a+x ${DEPLOY_DIR}/FRCUserProgram;
                /usr/local/frc/bin/frcKillRobot.sh -t -r;
                sync

                DEPENDS ${PROJECT_NAME})
    else()
        message(FATAL_ERROR "Could not deploy! ssh/scp executables not found!")
    endif()
endfunction()
