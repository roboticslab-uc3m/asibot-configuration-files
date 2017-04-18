find_package(YARP REQUIRED)
list(APPEND CMAKE_MODULE_PATH ${YARP_MODULE_PATH})
include(YarpInstallationHelpers)
yarp_configure_external_installation(asibot-configuration-files)

### Go through single applications

add_subdirectory(kinematics)
