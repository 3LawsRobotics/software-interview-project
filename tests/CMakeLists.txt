include(GoogleTest)

find_package(
  Python3
  COMPONENTS Interpreter Development NumPy
  REQUIRED
)

add_executable(main_test "${CMAKE_CURRENT_SOURCE_DIR}/test.cpp")
target_link_libraries(
  main_test
  PRIVATE 3laws::coding_interview_project
          Python3::Python
          Python3::Module
          Python3::NumPy
)
