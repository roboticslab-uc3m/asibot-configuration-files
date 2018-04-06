cmake_minimum_required(VERSION 2.8.9)

# Define a project.
project(ASIBOT_CONFIGURATION_FILES)

# Load custom CMake modules.
list(APPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake)

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

# Define CMAKE_INSTALL_<dir> and CMAKE_INSTALL_FULL_<dir> variables.
include(GNUInstallDirs)

# Set installation path for CMake files.
if(WIN32)
    set(${PROJECT_NAME}_CMAKE_DESTINATION CMake)
else()
    set(${PROJECT_NAME}_CMAKE_DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/${PROJECT_NAME})
endif()

file(WRITE ${CMAKE_BINARY_DIR}/${PROJECT_NAME}Config.cmake "# Dummy CMake configuration export file.")

install(FILES ${CMAKE_BINARY_DIR}/${PROJECT_NAME}Config.cmake
        DESTINATION ${${PROJECT_NAME}_CMAKE_DESTINATION})

# Configure and install desktop shortcut.
if(UNIX)
    include(DesktopShortcutHelpers)
    configure_and_install_desktop_shortcut(${CMAKE_SOURCE_DIR}/cmake/templates/asibot-apps.desktop.in)
endif()

# Add uninstall rule.
include(AddUninstallTarget)
