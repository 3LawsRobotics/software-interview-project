# Build type
if(NOT CMAKE_BUILD_TYPE AND NOT CMAKE_CONFIGURATION_TYPES)
  message(WARNING "Setting build type to 'Debug' as none was specified. Use -DCMAKE_BUILD_TYPE=...")
  set(CMAKE_BUILD_TYPE
      "Debug"
      CACHE
        STRING
        "Choose the type of build, options are: None Debug Release RelWithDebInfo MinSizeRel ..."
        FORCE
  )
  set_property(
    CACHE CMAKE_BUILD_TYPE
    PROPERTY STRINGS
             "Debug"
             "Release"
             "MinSizeRel"
             "RelWithDebInfo"
  )
elseif(NOT CMAKE_CONFIGURATION_TYPES)
  message(STATUS "CMAKE_BUILD_TYPE set to: ${CMAKE_BUILD_TYPE}")
endif()

# Position idenpendent code
set(CMAKE_POSITION_INDEPENDENT_CODE
    ON
    CACHE BOOL "Build position independent code."
)
message(STATUS "CMAKE_POSITION_INDEPENDENT_CODE set to: ${CMAKE_POSITION_INDEPENDENT_CODE}")

# Build tests
set(BUILD_TESTING
    ON
    CACHE BOOL "Build testing."
)
message(STATUS "BUILD_TESTING set to: ${BUILD_TESTING}")

if(CMAKE_CXX_COMPILER_ID MATCHES "Clang")
  set(FTIME_TRACE
      OFF
      CACHE BOOL "Enable ftime-trace (onlyclang currently supported)."
  )
else()
  message(WARNING "ftime-trace only supported with Clang, so it will NOT be activated")
  set(FTIME_TRACE
      OFF
      CACHE BOOL "Enable ftime-trace (only clangcurrently supported)." FORCE
  )
endif()
message(STATUS "FTIME_TRACE set to: ${FTIME_TRACE}")

# Compiler
message(STATUS "c++ compiler set to: ${CMAKE_CXX_COMPILER}")
