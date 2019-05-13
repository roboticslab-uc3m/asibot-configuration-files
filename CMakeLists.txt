cmake_minimum_required(VERSION 3.5 FATAL_ERROR)

# Define a project.
project(ASIBOT_CONFIGURATION_FILES LANGUAGES NONE)

# Load custom CMake modules.
list(APPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake)

# Find dependencies
find_package(YCM 0.10 REQUIRED)
find_package(YARP 3.0 REQUIRED)

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

# Create dummy CMake configuration export file.
file(WRITE ${CMAKE_BINARY_DIR}/${PROJECT_NAME}Config.cmake
     "# Dummy CMake configuration export file.")

# Install CMake configuration file.
install(FILES ${CMAKE_BINARY_DIR}/${PROJECT_NAME}Config.cmake
        DESTINATION ${${PROJECT_NAME}_CMAKE_DESTINATION})

# Configure and install desktop shortcut.
if(UNIX)
    include(DesktopShortcutHelpers)
    configure_and_install_desktop_shortcut(${CMAKE_SOURCE_DIR}/cmake/templates/asibot-apps.desktop.in)
endif()

# Add uninstall rule.
include(AddUninstallTarget)
