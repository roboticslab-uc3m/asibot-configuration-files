if(COMMAND configure_and_install_desktop_shortcut)
    return()
endif()

include(CMakeParseArguments)

function(configure_and_install_desktop_shortcut _source _dest)
    set(options)
    set(oneValueArgs)
    set(multiValueArgs)

    cmake_parse_arguments(_IDS "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

    get_filename_component(_template ${_dest} NAME)
    get_filename_component(_dest_dir ${_dest} DIRECTORY)

    # Configure desktop shortcut.
    configure_file(${_source} ${CMAKE_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/${_template} @ONLY)

    # Set execute permissions on shortcut.
    file(COPY ${CMAKE_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/${_template}
         DESTINATION ${_dest_dir}
         FILE_PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE
                          GROUP_READ GROUP_WRITE GROUP_EXECUTE
                          WORLD_READ WORLD_EXECUTE)

    # Find xdg-user-dir program.
    find_program(XdgUserDir_EXECUTABLE xdg-user-dir)
    set(_desktop_install_path)

    # Retrieve desktop location via xdg-user-dir or env variable.
    if(XdgUserDir_EXECUTABLE)
        execute_process(COMMAND ${XdgUserDir_EXECUTABLE} DESKTOP
                        RESULT_VARIABLE _result
                        OUTPUT_VARIABLE _output
                        ERROR_VARIABLE _error
                        OUTPUT_STRIP_TRAILING_WHITESPACE)

        if(NOT _result)
            set(_desktop_install_path "${_output}")
        else()
            message(WARNING "xdg-user-dir reports failure: ${_error}")
        endif()
    else()
        message(STATUS "xdg-user-dir not found.")

        if(NOT $ENV{HOME} STREQUAL "")
            set(_desktop_install_path "$ENV{HOME}")
        else()
            message(STATUS "$HOME env var not found.")
        endif()
    endif()

    # Install desktop shortcut.
    if(_desktop_install_path)
        message(STATUS "Installation path of desktop shortcut: ${_desktop_install_path}.")

        install(PROGRAMS ${CMAKE_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/${_template}
                DESTINATION "${_desktop_install_path}")
    else()
        message(STATUS "Not installing desktop shortcut.")
    endif()
endfunction()
