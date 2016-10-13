# frc-cpp-project-skeleton [![Build Status](https://travis-ci.org/Team5499/frc-cpp-project-skeleton.svg?branch=master)](https://travis-ci.org/Team5499/frc-cpp-project-skeleton)
This is a skeleton for FRC C++ projects using CMake.  Fork me!  Example usage:
```
cmake .
make # make your robot code
make deploy # deploy your robot code, configure team number in CMakeLists.txt
make doxygen # build doxygen docs
make ci-test # run tests, see test/
```

The ci-test target depends on Boost.Test.

The skeleton is Travis CI-ready and will automatically install the FRC toolchain, WPILib, and Boost.Test on the Travis instance.  The default script is:
```
cmake .
make
make ci-test
```  

TODO:
* Improve test/wpilib-harness and move it to its own repository
