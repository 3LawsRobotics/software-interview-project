cmake_minimum_required(VERSION 3.16)

project(
  3laws-coding_interview_project-dev
  VERSION 0.0.1
  LANGUAGES CXX
)

# --------------------------------------------------------------------------------------------------
# FLAGS
# --------------------------------------------------------------------------------------------------
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
set(CMAKE_CXX_STANDARD 23)
set(CMAKE_COLOR_DIAGNOSTICS ON)

include(${CMAKE_CURRENT_SOURCE_DIR}/cmake/Options.cmake)
include(${CMAKE_CURRENT_SOURCE_DIR}/cmake/CompilerFlags.cmake)

# --------------------------------------------------------------------------------------------------
# SOURCES
# --------------------------------------------------------------------------------------------------
add_subdirectory(sources)

# --------------------------------------------------------------------------------------------------
# TESTING
# --------------------------------------------------------------------------------------------------
if(BUILD_TESTING)
  enable_testing()
  add_subdirectory(tests)
endif()
