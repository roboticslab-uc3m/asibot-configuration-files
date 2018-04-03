if(COMMAND configure_desktop_shortcut)
    return()
endif()

include(CMakeParseArguments)

function(configure_desktop_shortcut)
    set(options NO_EXTENSION)
    set(oneValueArgs EXTENSION)
    set(multiValueArgs)

    cmake_parse_arguments(_IDS "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

    set(_arg ${ARGV0})

    if("${_arg}" STREQUAL "")
        message(SEND_ERROR "Missing argument to configure_desktop_shortcut().")
        return()
    endif()

    get_filename_component(_template_name ${_arg} NAME)

    set(_filename ${_template_name})

    if(NOT _IDS_NO_EXTENSION)
        set(_extension .in)

        if(_IDS_EXTENSION)
            set(_extension ${_IDS_EXTENSION})
        endif()

        string(REPLACE "." "\\." _extension_escaped ${_extension})
        string(REGEX REPLACE "${_extension_escaped}$" "" _filename ${_template_name})
    endif()

    string(REGEX MATCH ".+\\.desktop$" _valid_filename ${_filename})

    if(NOT _valid_filename)
        message(SEND_ERROR "Invalid desktop file: \"${_filename}\".")
        return()
    endif()

    # Configure desktop shortcut.
    configure_file(${_arg} ${CMAKE_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/${_filename} @ONLY)

    # Set execute permissions on shortcut.
    file(COPY ${CMAKE_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/${_filename}
         DESTINATION ${CMAKE_BINARY_DIR}
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

        install(PROGRAMS ${CMAKE_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/${_filename}
                DESTINATION "${_desktop_install_path}")
    else()
        message(STATUS "Not installing desktop shortcut.")
    endif()
endfunction()
