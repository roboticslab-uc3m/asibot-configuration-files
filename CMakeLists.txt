cmake_minimum_required(VERSION 3.12 FATAL_ERROR)

# Define a project.
project(ASIBOT_CONFIGURATION_FILES LANGUAGES NONE)

# Load custom CMake modules.
list(APPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake)

# Find dependencies
find_package(YCM 0.11 REQUIRED)
find_package(YARP 3.2 REQUIRED)

# Set some useful variables - paths relative to the installation prefix.
yarp_configure_external_installation(asibot)

# Traverse subdirectories.
add_subdirectory(share)
add_subdirectory(scripts)

# Store the package in the user registry.
set(CMAKE_EXPORT_PACKAGE_REGISTRY ON)

# Create and install config files.
include(InstallBasicPackageFiles)

install_basic_package_files(ASIBOT_CONFIGURATION_FILES
                            VERSION 0.1.0
                            COMPATIBILITY AnyNewerVersion
                            NO_EXPORT)

# Configure and install desktop shortcut.
if(UNIX)
    include(DesktopShortcutHelpers)
    configure_and_install_desktop_shortcut(${CMAKE_SOURCE_DIR}/cmake/templates/asibot-apps.desktop.in)
endif()

# Add uninstall rule.
include(AddUninstallTarget)
