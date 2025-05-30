# -*- mode:cmake -*-
cmake_minimum_required (VERSION 3.14)
# 2.8 needed because of ExternalProject

set(CMAKE_MACOSX_RPATH OFF)

# Detect build type, fallback to release and throw a warning if use didn't specify any
if(NOT CMAKE_BUILD_TYPE)
  message(WARNING "Build type not set, falling back to Release mode.
 To specify build type use:
 -DCMAKE_BUILD_TYPE=<mode> where <mode> is Debug or Release.")
  set(CMAKE_BUILD_TYPE "Release" CACHE STRING
       "Choose the type of build, options are: Debug Release."
       FORCE)
endif(NOT CMAKE_BUILD_TYPE)

if(NOT WITH_DEMO)
  message(STATUS "Building without demo. To enable demo build use: -DWITH_DEMO=True")
  set(WITH_DEMO False CACHE STRING
    "Chose to build with or without demo executable"
    FORCE)
endif(NOT WITH_DEMO)

option(WITH_LIBCXX "Building with clang++ and libc++(in Linux). To enable with: -DWITH_LIBCXX=On" On)
option(WITH_STATIC_CRT "(Visual C++) Enable to statically link CRT, which avoids requiring users to install the redistribution package.
 To disable with: -DWITH_STATIC_CRT=Off" On)

project(LIBANTLR4)

include(GNUInstallDirs)

if(CMAKE_SYSTEM_NAME MATCHES "Linux")
  find_package(PkgConfig REQUIRED)
  pkg_check_modules(UUID uuid)
  # try with ossp-uuid for CentOS
  if (NOT UUID_FOUND)
    pkg_check_modules(UUID REQUIRED ossp-uuid)
  endif()
endif()

if(APPLE)
  find_library(COREFOUNDATION_LIBRARY CoreFoundation)
endif()

file(STRINGS "VERSION" ANTLR_VERSION)

if(WITH_DEMO)
  # Java is not necessary if building without demos.
  find_package(Java COMPONENTS Runtime REQUIRED)

  if(NOT ANTLR_JAR_LOCATION)
    message(FATAL_ERROR "Missing antlr4.jar location. You can specify it's path using: -DANTLR_JAR_LOCATION=<path>")
  else()
    get_filename_component(ANTLR_NAME ${ANTLR_JAR_LOCATION} NAME_WE)
    if(NOT EXISTS "${ANTLR_JAR_LOCATION}")
      message(FATAL_ERROR "Unable to find ${ANTLR_NAME} in ${ANTLR_JAR_LOCATION}")
    else()
      message(STATUS "Found ${ANTLR_NAME}: ${ANTLR_JAR_LOCATION}")
    endif()
  endif()
endif(WITH_DEMO)

if(MSVC_VERSION)
  set(MY_CXX_WARNING_FLAGS "  /W4")
else()
  set(MY_CXX_WARNING_FLAGS "  -Wall -pedantic -W")
endif()

# Initialize CXXFLAGS.
if(CMAKE_VERSION VERSION_GREATER 3.1.0)
  set(CMAKE_CXX_STANDARD 11)
  set(CMAKE_CXX_STANDARD_REQUIRED ON)
else()
  set(CMAKE_CXX_FLAGS                "${CMAKE_CXX_FLAGS} -std=c++11")
  set(CMAKE_CXX_FLAGS_DEBUG          "${CMAKE_CXX_FLAGS_DEBUG} -std=c++11")
  set(CMAKE_CXX_FLAGS_MINSIZEREL     "${CMAKE_CXX_FLAGS_MINSIZEREL} -std=c++11")
  set(CMAKE_CXX_FLAGS_RELEASE        "${CMAKE_CXX_FLAGS_RELEASE} -std=c++11")
  set(CMAKE_CXX_FLAGS_RELWITHDEBINFO "${CMAKE_CXX_FLAGS_RELWITHDEBINFO} -std=c++11")
endif()

set(CMAKE_CXX_FLAGS                  "${CMAKE_CXX_FLAGS} ${MY_CXX_WARNING_FLAGS}")
if(MSVC_VERSION)
  set(CMAKE_CXX_FLAGS_DEBUG          "${CMAKE_CXX_FLAGS_DEBUG} /Od /Zi /MP ${MY_CXX_WARNING_FLAGS}")
  set(CMAKE_CXX_FLAGS_MINSIZEREL     "${CMAKE_CXX_FLAGS_MINSIZEREL} /O1 /Oi /Ob2 /Gy /MP /DNDEBUG ${MY_CXX_WARNING_FLAGS}")
  set(CMAKE_CXX_FLAGS_RELEASE        "${CMAKE_CXX_FLAGS_RELEASE} /O2 /Oi /Ob2 /Gy /MP /DNDEBUG ${MY_CXX_WARNING_FLGAS}")
  set(CMAKE_CXX_FLAGS_RELWITHDEBINFO "${CMAKE_CXX_FLAGS_RELWITHDEBINFO} /O2 /Oi /Ob2 /Gy /MP /Zi ${MY_CXX_WARNING_FLAGS}")
else()
  set(CMAKE_CXX_FLAGS_DEBUG          "${CMAKE_CXX_FLAGS_DEBUG} -O0 -g ${MY_CXX_WARNING_FLAGS}")
  set(CMAKE_CXX_FLAGS_MINSIZEREL     "${CMAKE_CXX_FLAGS_MINSIZEREL} -Os -DNDEBUG ${MY_CXX_WARNING_FLAGS}")
  set(CMAKE_CXX_FLAGS_RELEASE        "${CMAKE_CXX_FLAGS_RELEASE} -O3 -DNDEBUG ${MY_CXX_WARNING_FLGAS}")
  set(CMAKE_CXX_FLAGS_RELWITHDEBINFO "${CMAKE_CXX_FLAGS_RELWITHDEBINFO} -O2 -g ${MY_CXX_WARNING_FLAGS}")
endif()

# Compiler-specific C++11 activation.
if(CMAKE_CXX_COMPILER_ID MATCHES "GNU" OR CMAKE_CXX_COMPILER_ID MATCHES "Intel")
    execute_process(
        COMMAND ${CMAKE_CXX_COMPILER} -dumpversion OUTPUT_VARIABLE GCC_VERSION)
    # Just g++-5.0 and greater contain <codecvt> header. (test in ubuntu)
    if(NOT (GCC_VERSION VERSION_GREATER 5.0 OR GCC_VERSION VERSION_EQUAL 5.0))
        message(WARNING "${PROJECT_NAME} found a compiler that has no <codecvt> include, using alternative utf8 conversion")
    endif ()
elseif (CMAKE_CXX_COMPILER_ID MATCHES "Clang" AND ANDROID)
	# Need -Os cflag and cxxflags here to work with exception handling on armeabi.
	# see  https://github.com/android-ndk/ndk/issues/573
	# and without -stdlib=libc++ cxxflags
elseif (CMAKE_CXX_COMPILER_ID MATCHES "Clang" AND APPLE)
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11 -stdlib=libc++")
elseif (CMAKE_CXX_COMPILER_ID MATCHES "Clang" AND ( CMAKE_SYSTEM_NAME MATCHES "Linux" OR CMAKE_SYSTEM_NAME MATCHES "FreeBSD") )
    execute_process(
        COMMAND ${CMAKE_CXX_COMPILER} -dumpversion OUTPUT_VARIABLE CLANG_VERSION)
    if(NOT (CLANG_VERSION VERSION_GREATER 4.2.1 OR CLANG_VERSION VERSION_EQUAL 4.2.1))
        message(WARNING "${PROJECT_NAME} found a compiler that has no <codecvt> include, using alternative utf8 conversion")
    endif()
    # You can use libc++ to compile this project when g++ is NOT greater than or equal to 5.0.
    if(WITH_LIBCXX)
        set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -stdlib=libc++")
    endif()
elseif (CMAKE_CXX_COMPILER_ID MATCHES "Clang" AND WIN32) # msys2/mingw/clang
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11")
elseif(MSVC_VERSION GREATER 1800 OR MSVC_VERSION EQUAL 1800)
  # Visual Studio 2012+ supports c++11 features
elseif(CMAKE_SYSTEM_NAME MATCHES "Emscripten")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11 -stdlib=libc++")
else()
    message(FATAL_ERROR "Your C++ compiler does not support C++11.")
endif()


add_subdirectory(runtime)
if(WITH_DEMO)
 add_subdirectory(demo)
endif(WITH_DEMO)

# Generate CMake Package Files only if install is active
if (ANTLR4_INSTALL)

  include(CMakePackageConfigHelpers)

  if(NOT ANTLR4_CMAKE_DIR)
    set(ANTLR4_CMAKE_DIR ${CMAKE_INSTALL_LIBDIR}/cmake CACHE STRING
      "Installation directory for cmake files." FORCE )
  endif(NOT ANTLR4_CMAKE_DIR)

  set(version_runtime_config ${PROJECT_BINARY_DIR}/antlr4-runtime-config-version.cmake)
  set(version_generator_config ${PROJECT_BINARY_DIR}/antlr4-generator-config-version.cmake)
  set(project_runtime_config ${PROJECT_BINARY_DIR}/antlr4-runtime-config.cmake)
  set(project_generator_config ${PROJECT_BINARY_DIR}/antlr4-generator-config.cmake)
  set(targets_export_name antlr4-targets)

  set(ANTLR4_LIB_DIR ${CMAKE_INSTALL_LIBDIR} CACHE STRING
      "Installation directory for libraries, relative to ${CMAKE_INSTALL_PREFIX}.")

  set(ANTLR4_INCLUDE_DIR ${CMAKE_INSTALL_INCLUDEDIR}/antlr4-runtime CACHE STRING
      "Installation directory for include files, relative to ${CMAKE_INSTALL_PREFIX}.")

  configure_package_config_file(
    cmake/antlr4-runtime.cmake.in
    ${project_runtime_config}
    INSTALL_DESTINATION ${ANTLR4_CMAKE_DIR}/antlr4-runtime
    PATH_VARS
    ANTLR4_INCLUDE_DIR
    ANTLR4_LIB_DIR )

  configure_package_config_file(
    cmake/antlr4-generator.cmake.in
    ${project_generator_config}
    INSTALL_DESTINATION ${ANTLR4_CMAKE_DIR}/antlr4-generator
    PATH_VARS
    ANTLR4_INCLUDE_DIR
    ANTLR4_LIB_DIR )

  write_basic_package_version_file(
    ${version_runtime_config}
    VERSION ${ANTLR_VERSION}
    COMPATIBILITY SameMajorVersion )

  write_basic_package_version_file(
    ${version_generator_config}
    VERSION ${ANTLR_VERSION}
    COMPATIBILITY SameMajorVersion )

  install(EXPORT ${targets_export_name}
          DESTINATION ${ANTLR4_CMAKE_DIR}/antlr4-runtime )

  install(FILES ${project_runtime_config}
                ${version_runtime_config}
          DESTINATION ${ANTLR4_CMAKE_DIR}/antlr4-runtime )

  install(FILES ${project_generator_config}
                ${version_generator_config}
          DESTINATION ${ANTLR4_CMAKE_DIR}/antlr4-generator )

endif(ANTLR4_INSTALL)

# if(EXISTS LICENSE.txt)
# install(FILES LICENSE.txt
#         DESTINATION "share/doc/libantlr4")
# elseif(EXISTS ../../LICENSE.txt)
# install(FILES ../../LICENSE.txt
#     DESTINATION "share/doc/libantlr4")
# endif()

# install(FILES README.md VERSION
#     DESTINATION "share/doc/libantlr4")

set(CPACK_PACKAGE_CONTACT "antlr-discussion@googlegroups.com")
set(CPACK_PACKAGE_VERSION ${ANTLR_VERSION})
include(CPack)
