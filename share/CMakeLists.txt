yarp_install(FILES applications/ymanager.ini
                   applications/asibotBase.xml
                   applications/asibotSimBase.xml
                   applications/asibotTools.xml
             DESTINATION ${ASIBOT-CONFIGURATION-FILES_APPLICATIONS_INSTALL_DIR})

yarp_install(DIRECTORY yarpmotorgui
             DESTINATION ${ASIBOT-CONFIGURATION-FILES_DATA_INSTALL_DIR})

yarp_install(DIRECTORY contexts/kinematics
                       contexts/launchCanBus
             DESTINATION ${ASIBOT-CONFIGURATION-FILES_CONTEXTS_INSTALL_DIR})

yarp_install(DIRECTORY robots/asibot
             DESTINATION ${ASIBOT-CONFIGURATION-FILES_ROBOTS_INSTALL_DIR})
