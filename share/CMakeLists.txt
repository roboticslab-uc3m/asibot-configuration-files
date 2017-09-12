add_subdirectory(asibotBase)
add_subdirectory(asibotSimBase)
add_subdirectory(asibotTools)
add_subdirectory(kinematics)

yarp_install(FILES ymanager.ini
             DESTINATION ${ASIBOT_APPLICATIONS_INSTALL_DIR})
