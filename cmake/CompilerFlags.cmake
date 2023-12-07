if(NOT CMAKE_CXX_FLAGS_3LAWS_SET)
  set(CMAKE_CXX_FLAGS_3LAWS_SET true)

  # Export compile commands
  set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

  if(CMAKE_CXX_COMPILER_ID STREQUAL "GNU" OR CMAKE_CXX_COMPILER_ID MATCHES "Clang")
    if(UNIX)
      include(CheckCXXCompilerFlag)

      set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -pedantic -Wall -Wshadow -Wextra -Werror")
    elseif(WIN32)
      if(MSVC AND MSVC14)
        set(CMAKE_CXX_FLAGS_STD_CPP)
      else()
        message(FATAL_ERROR "Only the MSVC 2015 compiler is supported on windows.")
      endif()
    endif()

    include(CheckCXXCompilerFlag)

    # Additional warnings for GCC
    set(CMAKE_CXX_FLAGS_WARN
        "-Wnon-virtual-dtor -Wno-long-long -Wcast-align -Wchar-subscripts -Wall -Wpointer-arith -Wformat-security"
    )
    set(CMAKE_CXX_FLAGS_WARN "${CMAKE_CXX_FLAGS_WARN} -fno-common -Wconversion")

    if(CMAKE_CXX_COMPILER_ID MATCHES "Clang")
      set(CMAKE_CXX_FLAGS_WARN "${CMAKE_CXX_FLAGS_WARN} -Wextra-semi -Wshadow-all")
    endif()

    # If we are compiling on Linux then set some extra linker flags too
    if(CMAKE_SYSTEM_NAME MATCHES Linux)
      set(CMAKE_SHARED_LINKER_FLAGS
          "-Wl,--fatal-warnings -Wl,--no-undefined -lc ${CMAKE_SHARED_LINKER_FLAGS}"
      )
      set(CMAKE_MODULE_LINKER_FLAGS
          "-Wl,--fatal-warnings -Wl,--no-undefined -lc ${CMAKE_MODULE_LINKER_FLAGS}"
      )
    endif()

    # Set up the debug CXX_FLAGS for extra warnings
    set(CMAKE_CXX_FLAGS_DEBUG
        "${CMAKE_CXX_FLAGS_DEBUG} ${CMAKE_CXX_FLAGS_WARN} ${CMAKE_CXX_FLAGS_LIBDEBUG}"
    )
    set(CMAKE_CXX_FLAGS_RELWITHDEBINFO
        "${CMAKE_CXX_FLAGS_RELWITHDEBINFO} ${CMAKE_CXX_FLAGS_WARN} ${CMAKE_CXX_FLAGS_LIBDEBUG}"
    )

    include(${CMAKE_CURRENT_SOURCE_DIR}/cmake/CxxFlagsPrint.cmake)
  else()
    message(FATAL_ERROR "Only clang and GCC are currently supported")
  endif()
endif()
