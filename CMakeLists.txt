cmake_minimum_required(VERSION 2.8.9)

# Define a project.
project(ASIBOT_CONFIGURATION_FILES)

# Find YARP and load configuration, fail otherwise.
find_package(YARP REQUIRED)

# Make YARP's modules visible to current CMake file.
list(APPEND CMAKE_MODULE_PATH ${YARP_MODULE_PATH})

# Load yarp_configure_external_installation() and yarp_install().
include(YarpInstallationHelpers)

# Set some useful variables - paths relative to the installation prefix.
yarp_configure_external_installation(asibot)

# Traverse subdirectories.
add_subdirectory(share)

# Store this package in the user registry.
export(PACKAGE ${PROJECT_NAME})

# Load configure_package_config_file().
include(CMakePackageConfigHelpers)

# Define CMAKE_INSTALL_<dir> and CMAKE_INSTALL_FULL_<dir> variables.
include(GNUInstallDirs)

if(WIN32)
    set(${PROJECT_NAME}_CMAKE_DESTINATION "cmake")
else()
    set(${PROJECT_NAME}_CMAKE_DESTINATION "${CMAKE_INSTALL_LIBDIR}/cmake/${PROJECT_NAME}")
endif()

set(${PROJECT_NAME}_DATA_INSTALL_DIR "${ASIBOT_DATA_INSTALL_DIR}")

# Configure <project>Config.cmake file (build tree).
configure_package_config_file("${CMAKE_SOURCE_DIR}/cmake/template/${PROJECT_NAME}Config.cmake.in"
                              "${CMAKE_BINARY_DIR}/${PROJECT_NAME}Config.cmake"
                              INSTALL_DESTINATION "${CMAKE_BINARY_DIR}"
                              INSTALL_PREFIX "${CMAKE_BINARY_DIR}"
                              PATH_VARS ${PROJECT_NAME}_DATA_INSTALL_DIR
                              NO_CHECK_REQUIRED_COMPONENTS_MACRO)

# Configure <project>Config.cmake file (install tree).
configure_package_config_file("${CMAKE_SOURCE_DIR}/cmake/template/${PROJECT_NAME}Config.cmake.in"
                              "${CMAKE_BINARY_DIR}/${PROJECT_NAME}ConfigForInstall.cmake"
                              INSTALL_DESTINATION "${${PROJECT_NAME}_CMAKE_DESTINATION}"
                              PATH_VARS ${PROJECT_NAME}_DATA_INSTALL_DIR
                              NO_CHECK_REQUIRED_COMPONENTS_MACRO)

# Rename and install <project>Config.cmake file (install tree).
install(FILES "${CMAKE_BINARY_DIR}/${PROJECT_NAME}ConfigForInstall.cmake"
        RENAME ${PROJECT_NAME}Config.cmake
        DESTINATION "${${PROJECT_NAME}_CMAKE_DESTINATION}")

# Configure CMake uninstall script.
configure_file("${CMAKE_SOURCE_DIR}/cmake/template/${PROJECT_NAME}ConfigUninstall.cmake.in"
               "${CMAKE_BINARY_DIR}/${PROJECT_NAME}ConfigUninstall.cmake" @ONLY)

# Add uninstall rule.
add_custom_target(uninstall COMMAND ${CMAKE_COMMAND} -P
                  "${CMAKE_BINARY_DIR}/${PROJECT_NAME}ConfigUninstall.cmake")

# Configure desktop shortcut.
configure_file("${CMAKE_SOURCE_DIR}/cmake/template/asibot-apps.desktop.in"
               "${CMAKE_BINARY_DIR}/asibot-apps.desktop" @ONLY)
