include(CMakeForceCompiler)
set(CMAKE_SYSTEM_NAME Linux)
#set processor

find_program(ARM_CC arm-frc-linux-gnueabi-gcc)
find_program(ARM_CXX arm-frc-linux-gnueabi-g++)

cmake_force_c_compiler(${ARM_CC} GNU)
cmake_force_cxx_compiler(${ARM_CXX} GNU)

set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Wall -fmessage-length=0")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -fmessage-length=0")

string(REGEX REPLACE ";" " " CMAKE_C_FLAGS "${CMAKE_C_FLAGS}")
string(REGEX REPLACE ";" " " CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS}")

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
