# frc-cpp-project-skeleton
This is a skeleton for FRC C++ projects using CMake.  Fork me!  Example usage:
```
cmake .
make # make your robot code
make deploy # deploy your robot code, configure team number in CMakeLists.txt
make doxygen # build doxygen docs
make ci-test # run tests, see test/
```

The skeleton is Travis CI-ready and will automatically install the FRC toolchain and WPILib on the Travis instance.  The default script is:
```
cmake .
make
make ci-test
```  

TODO:
* Test that builds and deployment work on an actual roboRIO
* Improve test/wpilib-harness and move it to its own repository