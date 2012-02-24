set( TARGET_SWIG_VERSION 2.0.4 )
if(NOT SWIG_DIR)
  if(WIN32)
    # swig.exe available as pre-built binary on Windows:
    ExternalProject_Add(Swig
      URL http://prdownloads.sourceforge.net/swig/swigwin-${TARGET_SWIG_VERSION}.zip
      URL_MD5 4ab8064b1a8894c8577ef9d0fb2523c8
      SOURCE_DIR ${CMAKE_CURRENT_BINARY_DIR}/swigwin-${TARGET_SWIG_VERSION}
      CONFIGURE_COMMAND ""
      BUILD_COMMAND ""
      INSTALL_COMMAND ""
      )

    set(SWIG_DIR ${CMAKE_CURRENT_BINARY_DIR}/swigwin-${TARGET_SWIG_VERSION}) # ??
    set(SWIG_EXECUTABLE ${CMAKE_CURRENT_BINARY_DIR}/swigwin-${TARGET_SWIG_VERSION}/swig.exe)
  else()
    #
    #  PCRE (Perl Compatible Regular Expressions)
    #

    # follow the standard EP_PREFIX locations
    set ( pcre_binary_dir ${CMAKE_CURRENT_BINARY_DIR}/PCRE-prefix/src/PCRE-build )
    set ( pcre_source_dir ${CMAKE_CURRENT_BINARY_DIR}/PCRE-prefix/src/PCRE )
    set ( pcre_install_dir ${CMAKE_CURRENT_BINARY_DIR}/PCRE )

    configure_file(
      pcre_configure_step.cmake.in
      ${CMAKE_CURRENT_BINARY_DIR}/pcre_configure_step.cmake
      @ONLY)
    set ( pcre_CONFIGURE_COMMAND ${CMAKE_COMMAND} -P ${CMAKE_CURRENT_BINARY_DIR}/pcre_configure_step.cmake )

    ExternalProject_add(PCRE
      URL http://downloads.sourceforge.net/project/pcre/pcre/8.12/pcre-8.12.tar.gz
      URL_MD5 fa69e4c5d8971544acd71d1f10d59193
      CONFIGURE_COMMAND ${pcre_CONFIGURE_COMMAND}
      )

    #
    # SWIG
    #

    # swig uses bison find it by cmake and pass it down
    find_package ( BISON )
    set ( BISON_FLAGS "" CACHE STRING "Flags used by bison" )
    mark_as_advanced ( BISON_FLAGS )


    # follow the standard EP_PREFIX locations
    set ( swig_binary_dir ${CMAKE_CURRENT_BINARY_DIR}/Swig-prefix/src/Swig-build )
    set ( swig_source_dir ${CMAKE_CURRENT_BINARY_DIR}/Swig-prefix/src/Swig )
    set ( swig_install_dir ${CMAKE_CURRENT_BINARY_DIR}/Swig )

    configure_file(
      swig_configure_step.cmake.in
      ${CMAKE_CURRENT_BINARY_DIR}/swig_configure_step.cmake
      @ONLY)
    set ( swig_CONFIGURE_COMMAND ${CMAKE_COMMAND} -P ${CMAKE_CURRENT_BINARY_DIR}/swig_configure_step.cmake )

    ExternalProject_add(Swig
      URL http://prdownloads.sourceforge.net/swig/swig-${TARGET_SWIG_VERSION}.tar.gz
      URL_MD5  4319c503ee3a13d2a53be9d828c3adc0
      CONFIGURE_COMMAND ${swig_CONFIGURE_COMMAND}
      DEPENDS PCRE
      )

    set(SWIG_DIR ${swig_install_dir}/share/swig/${TARGET_SWIG_VERSION})
    set(SWIG_EXECUTABLE ${swig_install_dir}/bin/swig)
  endif()
endif(NOT SWIG_DIR)
