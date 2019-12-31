yarp_install(DIRECTORY applications/yarpmanager
                       applications/yarpmotorgui
             DESTINATION ${ASIBOT-CONFIGURATION-FILES_APPLICATIONS_INSTALL_DIR})

yarp_install(DIRECTORY contexts/kinematics
                       contexts/launchCanBus
             DESTINATION ${ASIBOT-CONFIGURATION-FILES_CONTEXTS_INSTALL_DIR})

yarp_install(DIRECTORY robots/asibot
             DESTINATION ${ASIBOT-CONFIGURATION-FILES_ROBOTS_INSTALL_DIR})
