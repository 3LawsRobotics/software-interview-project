cmake_minimum_required(VERSION 3.16)

project(
  3laws-coding_interview_project
  VERSION 0.0.1
  LANGUAGES CXX
)

# --------------------------------------------------------------------------------------------------
# INCLUDES
# --------------------------------------------------------------------------------------------------
include(GNUInstallDirs)
include(CMakePackageConfigHelpers)

# --------------------------------------------------------------------------------------------------
# TARGETS
# --------------------------------------------------------------------------------------------------

# Global target regrouping public and private targets
add_library(3laws-coding_interview_project INTERFACE)
add_library(3laws::coding_interview_project ALIAS 3laws-coding_interview_project)
target_include_directories(
  3laws-coding_interview_project INTERFACE $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
                                           $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>
)

# --------------------------------------------------------------------------------------------------
# INSTALLATION
# --------------------------------------------------------------------------------------------------

# Header files
install(DIRECTORY ${PROJECT_SOURCE_DIR}/include/3laws DESTINATION ${CMAKE_INSTALL_INCLUDEDIR})

# Targets
install(TARGETS 3laws-coding_interview_project EXPORT ${PROJECT_NAME}_targets)

# --------------------------------------------------------------------------------------------------
# CMAKE CONFIGURATION
# --------------------------------------------------------------------------------------------------

# Generate TARGETS files
install(
  EXPORT ${PROJECT_NAME}_targets
  FILE ${PROJECT_NAME}Targets.cmake
  NAMESPACE 3laws::
  DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/${PROJECT_NAME}
)

# Generate CONFIG file
configure_package_config_file(
  ${CMAKE_CURRENT_SOURCE_DIR}/config/config.cmake.in
  ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}Config.cmake
  INSTALL_DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/${PROJECT_NAME}
)

# Generate VERSION file
write_basic_package_version_file(
  ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}ConfigVersion.cmake
  VERSION ${PACKAGE_VERSION}
  COMPATIBILITY SameMajorVersion
)

# Install CONFIG and VERSION files
install(FILES ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}Config.cmake
              ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}ConfigVersion.cmake
        DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/${PROJECT_NAME}
)
